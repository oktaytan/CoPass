//
//  CoError.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 25.06.2023.
//

import Foundation

enum CoError: Error {
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
}
