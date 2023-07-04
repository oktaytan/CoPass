//
//  ObservationType.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 30.06.2023.
//

import Foundation

enum ObservationType<T, E> {
    case updateUI(data: T? = nil)
    case error(error: E?)
}
