//
//  SafetyUI.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 26.06.2023.
//

import Foundation

protocol SafetyUI: BaseUI {
    func load(with data: [SafetyPresenter.SectionType])
    func copyToPassword(password: String)
}
