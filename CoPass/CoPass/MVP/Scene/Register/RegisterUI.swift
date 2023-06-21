//
//  RegisterUI.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 22.05.2023.
//

import Foundation

enum RegisterError {
    case emptyUsername, emptyPassword, emptyRePassword, invalidUsername, invalidPassword, invalidRePassword
}

protocol RegisterUI: BaseUI {
    func registerError(error: RegisterError)
}
