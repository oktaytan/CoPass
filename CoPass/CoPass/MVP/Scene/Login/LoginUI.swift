//
//  LoginUI.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 22.05.2023.
//

import Foundation

protocol LoginUI: BaseUI {
    func load(username: String, hasBioAuth: Bool)
    func authenticationFail()
}
