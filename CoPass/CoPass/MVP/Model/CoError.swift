//
//  CoError.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 25.06.2023.
//

import Foundation

enum CoError: Error, CustomStringConvertible {
    
    case emptyField,
         emptyUsername,
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
         recordDeleteFailure,
         exportFailure,
         importFailure
    
    var description: String {
        switch self {
        case .notFoundUser: return "error_user_not_found".localized
        case .recordNotFound: return "error_record_not_found".localized
        case .exportFailure: return "error_export_records".localized
        case .importFailure: return "error_import_records".localized
        default: return "error_general".localized
        }
    }
}
