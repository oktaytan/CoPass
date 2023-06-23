//
//  FaceIDManager.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 24.06.2023.
//

import Foundation
import LocalAuthentication


final class BioAuthManager {
    
    static let shared = BioAuthManager()
    private init() {}
    
    let context = LAContext()
    var error: NSError?
    
    enum BiometricType: String {
        case none
        case touchID
        case faceID
    }
    
    func authenticate(completion: @escaping (Result<Bool, Error>) -> Void) {
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "login_faceID_reason".localized) { success, authError in
            if let authError = authError {
                completion(.failure(authError))
            } else {
                completion(.success(success))
            }
        }
    }
    
    var biometricType: BiometricType {
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .none
        }
        
        if #available(iOS 11.0, *) {
            switch context.biometryType {
            case .none:
                return .none
            case .touchID:
                return .touchID
            case .faceID:
                return .faceID
            @unknown default:
                break
            }
        }
        
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touchID : .none
    }
    
}
