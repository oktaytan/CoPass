//
//  CoStorage.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 24.06.2023.
//

import Foundation
import CoreData

protocol CoStorageProtocol {
    var hasFaceID: Bool { get }
    
    /// NOTIFICATIONS
    var notifications: [CoNotification] { get set }
    func removeNotificaiton(id: UUID)
    
    /// USER
    func register(with data: RegisterData) -> Result<Bool, CoError>
    func saveUser(data: RegisterData) -> Result<User, CoError>
    func fetchUser() -> Result<User, CoError>
    func getMasterPassword() -> String?
    func setMasterPassword(password: String)
    @discardableResult func updateUser(with object: User) -> Result<User, CoError>
    @discardableResult func deleteUser() -> Result<Bool, CoError>
    
    /// FACEID
    func authenticateWithFaceID(completion: @escaping (Bool) -> Void)
    
    /// RECORD
    func saveRecord(with entity: RecordEntity) -> Result<Record, CoError>
    func fetchRecord(with id: NSManagedObjectID) -> Result<Record, CoError>
    func fetchRecords() -> Result<[Record], CoError>
    func fetchRecords(with category: CoCategory) -> Result<[Record], CoError>
    @discardableResult func updateRecord(at id: NSManagedObjectID, with entity: Record) -> Result<Record, CoError>
    func deleteRecord(with id: NSManagedObjectID) -> Result<Bool, CoError>
    
    /// EXPORT & IMPORT
    func saveAndExport(url: URL?) -> Result<Bool, CoError>
    func loadRecords(file: String, seperator: String) -> Result<Bool, CoError>
}

final class CoStorage: CoStorageProtocol {
    
    static let shared = CoStorage()
    
    private var keychain: KeychainManager
    private var bioAuth: BioAuthManager
    private var fileManager: FileManager
    private var masterPassword = ""
    
    private init() {
        self.keychain = KeychainManager.standard
        self.bioAuth = BioAuthManager.shared
        self.fileManager = FileManager.default
        self.masterPassword = self.getMasterPassword() ?? ""
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: AppConstants.appName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var notifications: [CoNotification] = [] {
        didSet {
            Notification.setNotificationCount(notifications.count)
        }
    }
}


// MARK: - KEYCHAIN STACK
extension CoStorage {
    var hasFaceID: Bool {
        return bioAuth.biometricType == .faceID
    }
    
    func getMasterPassword() -> String? {
        guard let data = keychain.read(type: RegisterData.self) else { return nil }
        return data.password
    }
    
    func setMasterPassword(password: String) {
        self.masterPassword = password
    }
    
    func register(with data: RegisterData) -> Result<Bool, CoError> {
        let result = self.keychain.save(data)
        
        switch result {
        case .success(_):
            let saveResult = saveUser(data: data)
            switch saveResult {
            case .success(_):
                self.setMasterPassword(password: data.password)
                return .success(true)
            case .failure(_):
                return .failure(.failureRegister)
            }
        case .failure(_):
            return .failure(.failureRegister)
        }
    }
    
    func authenticateWithFaceID(completion: @escaping (Bool) -> Void)  {
        bioAuth.authenticate { result in
            switch result {
            case .success(let success):
                let userResult = self.fetchUser()
                switch userResult {
                case .success(let user):
                    user.lastLogin = .now
                    self.updateUser(with: user)
                    completion(success)
                case .failure(_):
                    completion(false)
                }
            case .failure(_):
                completion(false)
            }
        }
    }
}


// MARK: - CORE DATA STACK
extension CoStorage {
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - User
    func saveUser(data: RegisterData) -> Result<User, CoError> {
        let context = persistentContainer.viewContext
        
        let user = User(context: context)
        user.setValue(data.username, forKey: #keyPath(User.username))
        user.setValue(nil, forKey: #keyPath(User.image))
        user.setValue(Date.now, forKey: #keyPath(User.createdAt))
        user.setValue(false, forKey: #keyPath(User.isLogin))
        user.setValue(nil, forKey: #keyPath(User.lastLogin))
        
        do {
            try context.save()
            return .success(user)
        } catch {
            return .failure(.failureUserSave)
        }
    }
    
    func fetchUser() -> Result<User, CoError> {
        let context = persistentContainer.viewContext
        do {
            guard let user = try context.fetch(User.fetchRequest()).first else {
                return .failure(.notFoundUser)
            }
            
            return .success(user)
        } catch {
            return .failure(.notFoundUser)
        }
    }
    
    @discardableResult
    func updateUser(with object: User) -> Result<User, CoError> {
        let context = persistentContainer.viewContext
        
        do {
            guard let user = try context.existingObject(with: object.objectID) as? User else {
                return .failure(.notFoundUser)
            }
            
            user.setValue(object.username, forKey: #keyPath(User.username))
            user.setValue(object.image, forKey: #keyPath(User.image))
            user.setValue(Date.now, forKey: #keyPath(User.updatedAt))
            user.setValue(object.isLogin, forKey: #keyPath(User.isLogin))
            user.setValue(object.lastLogin, forKey: #keyPath(User.lastLogin))
            
            let registerData = RegisterData(username: user.username, password: self.masterPassword)
            let result = self.keychain.save(registerData)
            
            switch result {
            case .success(_):
                try context.save()
                return .success(user)
            case .failure(_):
                return .failure(.failureRegister)
            }
        } catch {
            return .failure(.failureUserSave)
        }
    }
    
    @discardableResult
    func deleteUser() -> Result<Bool, CoError> {
        let context = persistentContainer.viewContext
        
        switch fetchUser() {
        case .success(let user):
            context.delete(user)
            
            do {
                try context.save()
                keychain.delete()
                return .success(true)
            } catch {
                return .failure(.deleteUser)
            }
        case .failure(let error): return .failure(error)
        }
    }
}


// MARK: - RECORD
extension CoStorage {
    func saveRecord(with entity: RecordEntity) -> Result<Record, CoError> {
        let context = persistentContainer.viewContext
        
        let encryptedPassword = try! entity.password.aesEncrypt(key: AppConstants.cyrptoKey, iv: AppConstants.cyrptoIv)
        
        let record = Record(context: context)
        record.setValue(entity.platform, forKey: #keyPath(Record.platform))
        record.setValue(entity.entry, forKey: #keyPath(Record.entry))
        record.setValue(encryptedPassword, forKey: #keyPath(Record.password))
        record.setValue(entity.category.rawValue, forKey: #keyPath(Record.category))
        record.setValue(Date.now, forKey: #keyPath(Record.createdAt))
        record.setValue(Date.now, forKey: #keyPath(Record.updatedAt))
        record.setValue(0, forKey: #keyPath(Record.usageCount))
        
        do {
            try context.save()
            return .success(record)
        } catch {
            return .failure(.recordSaveFailure)
        }
    }
    
    func fetchRecord(with id: NSManagedObjectID) -> Result<Record, CoError> {
        let context = persistentContainer.viewContext
        
        do {
            guard let record = try context.existingObject(with: id) as? Record else {
                return .failure(.recordNotFound)
            }
            return .success(record)
        } catch {
            return .failure(.recordNotFound)
        }
    }
    
    func fetchRecords() -> Result<[Record], CoError> {
        let context = persistentContainer.viewContext
        do {
            let records = try context.fetch(Record.fetchRequest())
            return .success(records)
        } catch {
            return .failure(.recordNotFound)
        }
    }
    
    func fetchRecords(with category: CoCategory) -> Result<[Record], CoError> {
        let context = persistentContainer.viewContext
        
        do {
            let records = try context.fetch(Record.fetchRequestWith(category: category))
            return .success(records)
        } catch {
            return .failure(.recordNotFound)
        }
    }
    
    @discardableResult
    func updateRecord(at id: NSManagedObjectID, with entity: Record) -> Result<Record, CoError> {
        let context = persistentContainer.viewContext
        
        do {
            guard let record = try context.existingObject(with: id) as? Record else {
                return .failure(.recordNotFound)
            }
            
            record.setValue(entity.platform, forKey: #keyPath(Record.platform))
            record.setValue(entity.entry, forKey: #keyPath(Record.entry))
            record.setValue(entity.password, forKey: #keyPath(Record.password))
            record.setValue(entity.category, forKey: #keyPath(Record.category))
            record.setValue(Date.now, forKey: #keyPath(Record.updatedAt))
            record.setValue(entity.usageCount + 1, forKey: #keyPath(Record.usageCount))
            
            do {
                try context.save()
                return .success(record)
            } catch {
                return .failure(.recordUpdateFailure)
            }
        } catch {
            return .failure(.recordNotFound)
        }
    }
    
    @discardableResult
    func deleteRecord(with id: NSManagedObjectID) -> Result<Bool, CoError> {
        let context = persistentContainer.viewContext
        
        do {
            let object = try context.existingObject(with: id)
            context.delete(object)
            
            try context.save()
            return .success(true)
        } catch {
            return .failure(.recordDeleteFailure)
        }
    }
}


// MARK: - NOTIFICATION
extension CoStorage {
    func removeNotificaiton(id: UUID) {
        guard let index = self.notifications.firstIndex(where: { $0.id == id }) else { return }
        self.notifications.remove(at: index)
    }
}


// MARK: - EXPORT & IMPORT
extension CoStorage {
    private func exportString() -> String? {
        let dateFormatter = DateFormatter(format: "dd/MM/YYYY HH:mm")
        var export: String = NSLocalizedString("Platform, Entry, Password, Created, Updated, Usage Count, Category \n", comment: "")
        
        let result = self.fetchRecords()
        switch result {
        case .success(let records):
            records.forEach { record in
                export.append("\(record.platform),")
                export.append("\(record.entry),")
                export.append("\(record.decryptedPassword),")
                export.append("\(record.createdAt.toString(dateFormatter: dateFormatter) ?? ""),")
                export.append("\(record.updatedAt?.toString(dateFormatter: dateFormatter) ?? ""),")
                export.append("\(record.usageCount),")
                export.append("\(record.category)\n")
            }
            
           return export
        case .failure:
            return nil
        }
    }
    
    func saveAndExport(url: URL?) -> Result<Bool, CoError> {
        guard let exportString = exportString(), let exportFileURL = url?.appendingPathComponent("\(AppConstants.appName)").appendingPathExtension("csv") else {
            return .failure(.exportFailure)
        }
        
        let path = exportFileURL.path()
        if fileManager.fileExists(atPath: path) {
            do {
                try fileManager.removeItem(atPath: path)
            } catch {
                return .failure(.exportFailure)
            }
        }
        
        do {
            try exportString.write(to: exportFileURL, atomically: true, encoding: .utf8)
            return .success(true)
        } catch {
            return .failure(.exportFailure)
        }
    }
    
    func loadRecords(file: String, seperator: String) -> Result<Bool, CoError> {
        let fileExtension = file.fileExtension()
        let fileName = file.fileName()
        
        do {
            let fileURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let inputFile = fileURL.appendingPathComponent(fileName).appendingPathExtension(fileExtension)
            
            let savedData = try String(contentsOf: inputFile)
            var arrayData = savedData.components(separatedBy: seperator)
            
            arrayData.remove(at: 0)
            let _ = arrayData.popLast()
            
            arrayData.forEach { recordString in
                let recordEntity = recordString.components(separatedBy: ",")
                let _ = self.saveRecord(with: RecordEntity(platform: recordEntity[0],
                                                   entry: recordEntity[1],
                                                   password: recordEntity[2],
                                                   category: CoCategory(rawValue: recordEntity[6]) ?? .app))
            }
            
            return .success(true)
        } catch {
            print(error.localizedDescription)
            return .failure(.importFailure)
        }
    }
}
