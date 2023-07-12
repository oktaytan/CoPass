//
//  UserUI.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 12.07.2023.
//

import Foundation

protocol UserUI: BaseUI {
    func load(user: User, password: String)
    func showError(error: CoError)
    func saveDone()
}
