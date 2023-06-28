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
    func getUser() -> Result<User, CoError>
    func updateUser(with user: User) -> Result<User, CoError>
    func deleteUser() -> Result<Bool, CoError>
    
    /// FACEID
    func authenticateWithFaceID(completion: @escaping (Bool) -> Void)
    
    /// RECORD
    func saveRecord(with entity: RecordEntity) -> Result<Record, CoError>
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
        user.username = data.username
        user.image = nil
        user.createdAt = .now
        user.isLogin = false
        
        do {
            try context.save()
            return .success(user)
        } catch {
            return .failure(.failureUserSave)
        }
    }
    
    func getUser() -> Result<User, CoError> {
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
    
    func updateUser(with data: User) -> Result<User, CoError> {
        let context = persistentContainer.viewContext
        
        switch getUser() {
        case .success(let user):
            
            user.username = data.username
            user.image = data.image
            user.updatedAt = .now
            user.isLogin = data.isLogin
            
            do {
                try context.save()
                return .success(user)
            } catch {
                return .failure(.failureUserSave)
            }
        case .failure(let error): return .failure(error)
        }
    }
    
    @discardableResult
    func deleteUser() -> Result<Bool, CoError> {
        let context = persistentContainer.viewContext
        
        switch getUser() {
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
        let record = Record(context: context)
        record.id = UUID()
        record.platform = entity.platform
        record.entry = entity.entry
        record.password = entity.password
        record.category = entity.category.rawValue
        record.createdAt = .now
        record.updatedAt = .now
        
        do {
            try context.save()
            return .success(record)
        } catch {
            return .failure(.recordSaveFailure)
        }
    }
    
    func getRecord(with id: UUID) -> Result<Record, CoError> {
        let context = persistentContainer.viewContext
        
        switch getRecords() {
        case .success(let records):
            guard let record = records.first(where: { $0.id == id }) else {
                return .failure(.recordNotFound)
            }
            
            return .success(record)
        case .failure:
            return .failure(.recordNotFound)
        }
    }
    
    func getRecords() -> Result<[Record], CoError> {
        let context = persistentContainer.viewContext
        do {
            let records = try context.fetch(Record.fetchRequest())
            return .success(records)
        } catch {
            return .failure(.recordNotFound)
        }
    }
    
    func updateRecord(with entity: Record) -> Result<Record, CoError> {
        let context = persistentContainer.viewContext
        
        switch getRecord(with: entity.id) {
        case .success(let record):
            record.id = entity.id
            record.platform = entity.platform
            record.entry = entity.entry
            record.category = entity.category
            record.password = entity.password
            record.updatedAt = .now
            
            do {
                try context.save()
                return .success(record)
            } catch {
                return .failure(.recordUpdateFailure)
            }
            
        case .failure:
            return .failure(.recordUpdateFailure)
        }
    }
    
    @discardableResult
    func deleteRecord(with id: UUID) -> Result<Bool, CoError> {
        let context = persistentContainer.viewContext
        
        switch getRecord(with: id) {
        case .success(let record):
            context.delete(record)
            
            do {
                try context.save()
                return .success(true)
            } catch {
                return .failure(.recordDeleteFailure)
            }
        case .failure:
            return .failure(.recordDeleteFailure)
        }
    }
}
