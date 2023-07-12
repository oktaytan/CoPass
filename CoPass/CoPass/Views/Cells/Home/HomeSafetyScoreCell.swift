//
//  HomeSafetyScoreCell.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 3.07.2023.
//

import UIKit

class HomeSafetyScoreCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pieChartViewContainer: UIView!
    @IBOutlet weak var safetyScoreLabel: UILabel!
    @IBOutlet weak var passwordCountLabel: UILabel!
    
    private lazy var chartView: CoPieChartView = {
        let view = CoPieChartView()
        view.frame = pieChartViewContainer.bounds
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        self.containerView.cornerRadius = AppConstants.appUIRadius
        pieChartViewContainer.addSubview(chartView)
        safetyScoreLabel.text = Strings.safetyScoreTitle
    }
    
    func setScore(with value: Float, count: Int, type: CoSafetyType) {
        self.containerView.backgroundColor = type.bg
        safetyScoreLabel.textColor = type.color
        chartView.configure(width: 10.0, color: type.color, proportion: value, textFont: 12, textWeight: .medium, textColor: .coText)
        let countText = count > 1 ? Strings.safetyPasswordCountPlural : Strings.safetyPasswordCountSingular
        passwordCountLabel.text = String(format: countText, count)
    }
}


extension HomeSafetyScoreCell {
    struct Strings {
        static let safetyScoreTitle = "safety_score_title".localized
        static let safetyPasswordCountSingular = "password_count_singular".localized
        static let safetyPasswordCountPlural = "password_count_plural".localized
    }
    
    enum UserActionEvent {
        case avatarTapped, notifyTapped
    }
}
