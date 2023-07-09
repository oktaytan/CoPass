//
//  Notification.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 2.07.2023.
//

import Foundation

extension Notification.Name {
    static let notificationCount = Notification.Name(rawValue: AppConstants.NOTIFICATION_COUNT)
    static let recordsUpdated = Notification.Name(rawValue: AppConstants.RECORDS_UPDATED)
}


extension Notification {
    static func setNotificationCount(_ count: Int) {
        NotificationCenter.default.post(name: .notificationCount, object: nil, userInfo: [AppConstants.NOTIFICATION_COUNT : count])
    }
    
    static func recordsUpdated() {
        NotificationCenter.default.post(name: .recordsUpdated, object: nil, userInfo: nil)
    }
}
