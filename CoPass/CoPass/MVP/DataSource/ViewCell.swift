//
//  ViewCell.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 27.06.2023.
//

import UIKit

protocol ViewCell {
    static var reuseIndentifier: String { get }
    static var identifier: String { get }
    
    associatedtype ItemType
    func configure(for item: ItemType)
}

extension ViewCell {
    static var reuseIndentifier: String { return String(describing: Self.self) }
    static var identifier: String { return String(describing: Self.self) }
}
