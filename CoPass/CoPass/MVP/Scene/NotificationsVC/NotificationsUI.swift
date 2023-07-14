//
//  NotificationsUI.swift.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 14.07.2023.
//

import Foundation

protocol NotificationsUI: BaseUI {
    func load(notifications: [NotificationsPresenter.RowType])
}
