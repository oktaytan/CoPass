//
//  BaseTableViewProvider.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 30.06.2023.
//

import Foundation

protocol BaseTableViewProvider {
    associatedtype T
    associatedtype I
    
    var dataList: [T]? { get set }
    func didSelectItem(at: I)
}

extension BaseTableViewProvider {
    func didSelectItem(at: I) {}
}
