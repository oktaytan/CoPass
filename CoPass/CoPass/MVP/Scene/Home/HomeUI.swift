//
//  HomeUI.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 24.06.2023.
//

import Foundation

protocol HomeUI: BaseUI {
    func load(with data: [HomePresenter.SectionType])
}
