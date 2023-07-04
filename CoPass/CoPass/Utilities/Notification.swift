//
//  Notification.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 2.07.2023.
//

import Foundation

extension Notification.Name {
    static let notificationCount = Notification.Name(rawValue: AppConstants.NOTIFICATION_COUNT)
}


extension Notification {
    static func setNotificationCount(_ count: Int) {
        NotificationCenter.default.post(name: .notificationCount, object: nil, userInfo: [AppConstants.NOTIFICATION_COUNT : count])
    }
}
