//
//  BaseUI.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 19.05.2023.
//

import Foundation

protocol BaseUI: AnyObject {
    func showAlert(title: String?, message: String?, error: Bool)
    func showBottomPopup(message: String?)
}
