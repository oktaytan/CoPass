//
//  BaseCollectionViewProvider.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 30.06.2023.
//

import Foundation

protocol BaseCollectionViewProvider {
    associatedtype T
    associatedtype I
    
    var dataList: [T]? { get set }
    func setupCollectionViewLayout()
    func didSelectItem(at: I)
}

extension BaseCollectionViewProvider {
    func setupCollectionViewLayout() {}
    func didSelectItem(at: I) {}
}
