//
//  CoStorage.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 24.06.2023.
//

import Foundation
import CoreData

protocol CoStorageProtocol {
    var masterPassword: String? { get }
    var hasFaceID: Bool { get }
    
    /// USER
    func register(with data: RegisterData) -> Result<Bool, CoError>
    func saveUser(data: RegisterData) -> Result<User, CoError>
    func fetchUser() -> Result<User, CoError>
    func updateUser(with object: User) -> Result<User, CoError>
    func deleteUser() -> Result<Bool, CoError>
    
    /// FACEID
    func authenticateWithFaceID(completion: @escaping (Bool) -> Void)
    
    /// RECORD
    func saveRecord(with entity: RecordEntity) -> Result<Record, CoError>
    func fetchRecord(with id: NSManagedObjectID) -> Result<Record, CoError>
    func fetchRecords() -> Result<[Record], CoError>
    func fetchRecords(with category: CoCategory) -> Result<[Record], CoError>
    func updateRecord(at id: NSManagedObjectID, with entity: Record) -> Result<Record, CoError>
    func deleteRecord(with id: NSManagedObjectID) -> Result<Bool, CoError>
}

final class CoStorage: CoStorageProtocol {
    
    static let shared = CoStorage()
    
    private var keychain: KeychainManager
    private var bioAuth: BioAuthManager
     
    private init() {
        self.keychain = KeychainManager.standard
        self.bioAuth = BioAuthManager.shared
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
}


// MARK: - KEYCHAIN STACK
extension CoStorage {
    var masterPassword: String? {
        guard let data = keychain.read(type: RegisterData.self) else { return nil }
        return data.password
    }
    
    var hasFaceID: Bool {
        return bioAuth.biometricType == .faceID
    }
    
    func register(with data: RegisterData) -> Result<Bool, CoError> {
        let result = self.keychain.save(data)
        
        switch result {
        case .success(_):
            let saveResult = saveUser(data: data)
            switch saveResult {
            case .success(_):
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
                completion(success)
            case .failure(_):
                break
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
            
            try context.save()
            return .success(user)
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
