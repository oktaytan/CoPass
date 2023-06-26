//
//  RegisterUI.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 22.05.2023.
//

import Foundation

protocol RegisterUI: BaseUI {
    func showError(error: CoError)
    func registerDone()
}
