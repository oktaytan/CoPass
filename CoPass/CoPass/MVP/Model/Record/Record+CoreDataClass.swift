//
//  Record+CoreDataClass.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 5.07.2023.
//
//

import Foundation
import CoreData

@objc(Record)
public class Record: NSManagedObject {

    var decryptedPassword: String {
        return try! self.password.aesDecrypt(key: AppConstants.cyrptoKey, iv: AppConstants.cyrptoIv)
    }
    
}
