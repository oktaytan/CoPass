//
//  ExportImportWireframe.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 16.07.2023.
//

import UIKit

protocol ExportImportWireframeProtocol: AnyObject {
    func navigate(to route: Router.ExportImport)
}

final class ExportImportWireframe: BaseWireframe, ExportImportWireframeProtocol {
    
    static func prepare() -> ExportImportVC {
        let view = ExportImportVC(nibName: ExportImportVC.className, bundle: nil)
        let wireframe = ExportImportWireframe()
        let presenter = ExportImportPresenter(ui: view, wireframe: wireframe, storage: CoStorage.shared)
        view.presenter = presenter
        wireframe.view = view
        return view
    }
    
    func navigate(to route: Router.ExportImport) {
        switch route {
        case .dismiss:
            backward(animated: true)
        case .export(let path, let completion):
            exportRecords(path: path, completion: completion)
        }
    }
}

extension ExportImportWireframe {
    private func exportRecords(path: URL?, completion: @escaping ((Bool) -> Void)) {
        let exportSheet = UIActivityViewController(activityItems: [path as Any], applicationActivities: nil)
        
        exportSheet.excludedActivityTypes = [
            .assignToContact,
            .airDrop,
            .addToReadingList,
            .mail,
            .markupAsPDF,
            .message,
        ]
        
        exportSheet.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed:
        Bool, arrayReturnedItems: [Any]?, error: Error?) in
            completion(completed)
        }
        
        forward(exportSheet, with: .present(from: self.view))
    }
}

