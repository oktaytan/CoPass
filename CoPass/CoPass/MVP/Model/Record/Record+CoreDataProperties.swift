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
    @NSManaged public var entry: String
    @NSManaged public var password: String
    @NSManaged public var category: String
    @NSManaged public var createdAt: Date
    @NSManaged public var updatedAt: Date?
    @NSManaged public var usageCount: Int16

}

extension Record : Identifiable {
    
}

extension [Record] {
    func getStrongPasswords() -> Self {
        let passRegEx = "\\A(?=[^a-z]*[a-z])(?=[^0-9]*[0-9])[a-zA-Z0-9!@#$%^&*]{8,}\\z"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passRegEx)
        return self.filter { passwordTest.evaluate(with: $0.decryptedPassword) == true }
    }
    
    func getWeakPasswords() -> Self {
        let strongPasswords = getStrongPasswords()
        return self.difference(from: strongPasswords)
    }
    
    func getReusedPasswords() -> Self {
        var reusedPasswords = [Record]()
        for record in self {
            if reusedPasswords.first(where: { $0.decryptedPassword != record.decryptedPassword }) != nil {
                continue
            }
            reusedPasswords.append(record)
        }
        
        return reusedPasswords.count == 1 ? [] : reusedPasswords
    }
    
    func setRecordsWithSafetyGroup() -> [CoScoreGroup : [Record]] {
        return [.strong : getStrongPasswords(), .weak : getWeakPasswords(), .reused : getReusedPasswords()]
    }
    
    func getCategories() -> [CoCategory : Int] {
        var categories: [CoCategory : Int] = [:]
        
        CoCategory.allCases.forEach { category in
            categories[category] = 0
        }
        
        self.forEach { record in
            let category = record.category
            guard let coCategory = CoCategory(rawValue: category) else { return }
            categories[coCategory] = self.filter({ $0.category == category }).count
        }
        
        return categories
    }
    
    var score: Float {
        return Float(((getStrongPasswords().count) * 100) / count)
    }
}
