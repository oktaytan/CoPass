//
//  Data+Ext.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 30.06.2023.
//

import Foundation

extension Data {

    var bytes: Array<UInt8> {
        return Array(self)
    }

    func toHexString() -> String {
        return bytes.toHexString()
    }

}
