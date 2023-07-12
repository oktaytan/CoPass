//
//  User+CoreDataProperties.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 30.06.2023.
//
//

import Foundation
import CoreData

extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        fetchRequest.fetchLimit = 1
        return fetchRequest
    }

    @NSManaged public var username: String
    @NSManaged public var image: Data?
    @NSManaged public var createdAt: Date
    @NSManaged public var updatedAt: Date?
    @NSManaged public var isLogin: Bool
    @NSManaged public var lastLogin: Date?

}

extension User : Identifiable {

}
