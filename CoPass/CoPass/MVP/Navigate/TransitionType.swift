//
//  TransitionType.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 19.05.2023.
//

import UIKit

enum TransitionType {
    case push, present(from: UIViewController), modal(from: UIViewController), pageSheet(from: UIViewController), root(window: UIWindow)
}
