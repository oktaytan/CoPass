//
//  KeychainManager.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 22.06.2023.
//

import Foundation

enum KeychainError: Error {
    case failureSave, failureUpdate, failureEncoding, failureDecoding
}

final class KeychainManager {
    
    static let standard = KeychainManager()
    private init() {}
    
    private let service = AppConstants.keychainService
    private let account = AppConstants.keychainAccount
    
    func save(_ data: Data) -> Result<Bool, KeychainError> {
        
        let query = [
            kSecValueData: data,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword
        ] as [CFString : Any] as CFDictionary
        
        // Add data in query to keychain
        let status = SecItemAdd(query, nil)
        
        if status == errSecDuplicateItem {
            // Item already exist, thus update it
            let query = [
                kSecAttrService: service,
                kSecAttrAccount: account,
                kSecClass: kSecClassGenericPassword
            ] as [CFString : Any] as CFDictionary
            
            let attributesToUpdate = [kSecValueData: data] as CFDictionary
            
            // Update existing item
            let updateStatus = SecItemUpdate(query, attributesToUpdate)
            
            if updateStatus == errSecSuccess {
                return .success(true)
            } else {
                return .failure(.failureUpdate)
            }
        }
        
        if status == errSecSuccess {
            return .success(true)
        } else {
            return .failure(.failureSave)
        }
    }
    
    func read() -> Data? {
        
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as [CFString : Any] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        return (result as? Data)
    }
    
    func delete() {
        
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword
        ] as [CFString : Any] as CFDictionary
        
        // Delete item from keychain
        SecItemDelete(query)
    }
    
    // MARK: - GLOBAL PROPERTIES
    lazy var masterPassword: String? = {
        guard let user = self.read(type: RegisterData.self) else { return nil }
        return user.password
    }()
}


extension KeychainManager {
    //If we want to save something else from Data class, such as a custom Authentication struct, we can use this generic functions
    
    func save<T>(_ item: T) -> Result<Bool, KeychainError> where T: Codable {
        
        do {
            // Encode as JSIN data and save in keychain
            let data = try JSONEncoder().encode(item)
            return save(data)
        } catch {
            assertionFailure("Fail to encode item for keychain: \(error)")
            return .failure(.failureEncoding)
        }
        
    }
    
    func read<T>(type: T.Type) -> T? where T: Codable {
        
        // Read item data from keychain
        guard let data = read() else {
            return nil
        }
        
        // Decode JSON data to object
        do {
            let item = try JSONDecoder().decode(type, from: data)
            return item
        } catch {
            assertionFailure("Fail to decode item for keychain: \(error)")
            return nil
        }
    }
}
