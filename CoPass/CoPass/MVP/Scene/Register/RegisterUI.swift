//
//  RegisterUI.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 22.05.2023.
//

import Foundation

enum RegisterError {
    case emptyUsername, emptyPassword, emptyRePassword, invalidUsername, invalidPassword, invalidRePassword, failureRegister
}

protocol RegisterUI: BaseUI {
    func showError(error: RegisterError)
    func registerDone()
}
