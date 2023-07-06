//
//  StoreUI.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 26.06.2023.
//

import Foundation

protocol StoreUI: BaseUI {
    func load(with data: [StorePresenter.SectionType])
    func copyToPassword(password: String)
}
