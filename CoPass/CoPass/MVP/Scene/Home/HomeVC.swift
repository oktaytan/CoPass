//
//  HomeVC.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 24.06.2023.
//

import UIKit
import SkeletonView

final class HomeVC: BaseViewController {
    
    var presenter: HomePresenterProtocol!
    @IBOutlet weak var testLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        
        testLabel.isSkeletonable = true
        testLabel.showAnimatedGradientSkeleton()
    }
    
}


extension HomeVC: HomeUI {
    
}
