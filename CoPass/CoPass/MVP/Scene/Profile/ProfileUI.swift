//
//  ProfileUI.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 26.06.2023.
//

import Foundation

protocol ProfileUI: BaseUI {
    func load(with data: [ProfilePresenter.SectionType])
}
