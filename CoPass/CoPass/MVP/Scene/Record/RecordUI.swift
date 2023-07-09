//
//  RecordUI.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 26.06.2023.
//

import Foundation

enum RecordStatusType {
    case add, update
}

protocol RecordUI: BaseUI {
    func load(data: [RecordPresenter.SectionType], with status: RecordStatusType)
    func validation(status: Bool)
}
