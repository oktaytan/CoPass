//
//  User+CoreDataProperties.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 24.06.2023.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var image: Data?
    @NSManaged public var username: String
    @NSManaged public var createdAt: Date
    @NSManaged public var updatedAt: Date?
    @NSManaged public var isLogin: Bool

}

extension User : Identifiable {

}
