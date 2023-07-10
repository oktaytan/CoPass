//
//  SafetyScoreEntity.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 9.07.2023.
//

import Foundation

struct SafetyScoreEntity {
    let groups: [CoScoreGroup: [Record]]
    let score: Float
    let type: CoSafetyType
    let totalRecord: Int
    
    init(data: [Record]) {
        self.groups = data.setRecordsWithSafetyGroup()
        self.score = data.score
        self.type = CoSafetyType.getScoreType(data.score)
        self.totalRecord = data.count
    }
}
