//
//  Record+CoreDataProperties.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 5.07.2023.
//
//

import Foundation
import CoreData


extension Record {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Record> {
        let request = NSFetchRequest<Record>(entityName: "Record")
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        return request
    }
    
    @nonobjc class func fetchRequestWith(category: CoCategory) -> NSFetchRequest<Record> {
        let request = NSFetchRequest<Record>(entityName: "Record")
        request.predicate = NSPredicate(format: "category = %@", category.rawValue)
        return request
    }

    @NSManaged public var platform: String
    @NSManaged public var entry: String?
    @NSManaged public var password: String
    @NSManaged public var category: String
    @NSManaged public var createdAt: Date
    @NSManaged public var updatedAt: Date?
    @NSManaged public var usageCount: Int16

}

extension Record : Identifiable {

}
