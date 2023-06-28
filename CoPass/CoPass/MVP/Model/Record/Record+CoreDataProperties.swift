//
//  Record+CoreDataProperties.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 28.06.2023.
//
//

import Foundation
import CoreData


extension Record {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Record> {
        let request = NSFetchRequest<Record>(entityName: "Record")
        return request
    }

    @NSManaged public var id: UUID
    @NSManaged public var platform: String
    @NSManaged public var entry: String?
    @NSManaged public var password: String
    @NSManaged public var category: String
    @NSManaged public var createdAt: Date
    @NSManaged public var updatedAt: Date?

}

extension Record : Identifiable {

}
