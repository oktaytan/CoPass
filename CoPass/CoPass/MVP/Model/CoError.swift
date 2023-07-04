//
//  CoError.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 25.06.2023.
//

import Foundation

enum CoError: Error, CustomStringConvertible {
    
    case emptyUsername,
         emptyPassword,
         emptyRePassword,
         invalidUsername,
         invalidPassword,
         invalidRePassword,
         failureRegister,
         failureUserSave,
         unknownError,
         notFoundUser,
         deleteUser,
         recordNotFound,
         recordSaveFailure,
         recordGetFailure,
         recordUpdateFailure,
         recordDeleteFailure
    
    var description: String {
        switch self {
        case .notFoundUser: return "error_user_not_found".localized
        case .recordNotFound: return "error_record_not_found".localized
        default: return "error_general".localized
        }
    }
}
