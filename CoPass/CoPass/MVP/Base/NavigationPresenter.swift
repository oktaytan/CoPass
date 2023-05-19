//
//  NavigationPresenter.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 19.05.2023.
//

import Foundation

protocol NavigationPresenter: Presenter {
    associatedtype ItemType
    func tapped(_ item: ItemType)
}
