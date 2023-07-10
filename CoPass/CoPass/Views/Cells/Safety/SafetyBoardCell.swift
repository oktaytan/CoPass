//
//  SafetyBoardCell.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 9.07.2023.
//

import UIKit

protocol SafetyBoardCellDelegate: AnyObject {
    func changeGroup(group: CoScoreGroup)
}

extension SafetyBoardCellDelegate {
    func changeGroup(group: CoScoreGroup) {}
}

class SafetyBoardCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var totalRecordLabel: UILabel!
    @IBOutlet weak var pieChartViewContainer: UIView!
    @IBOutlet weak var safetyLabel: UILabel!
    @IBOutlet weak var scoreTypeStackView: UIStackView!
    
    @IBOutlet weak var strongScoreLabel: UILabel!
    @IBOutlet weak var weakScoreLabel: UILabel!
    @IBOutlet weak var reusedScoreLabel: UILabel!
    
    @IBOutlet weak var strongLabel: UILabel!
    @IBOutlet weak var weakLabel: UILabel!
    @IBOutlet weak var reusedLabel: UILabel!
    
    weak var delegate: SafetyBoardCellDelegate?
    
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
        containerView.cornerRadius = AppConstants.appUIRadius
        scoreTypeStackView.cornerRadius = AppConstants.appUIRadius
        pieChartViewContainer.addSubview(chartView)
        safetyLabel.text = Strings.safetyScoreTitle
        
        strongLabel.text = Strings.strongScoreTitle
        weakLabel.text = Strings.weakScoreTitle
        reusedLabel.text = Strings.reusedScoreTitle
    }
    
    func set(with data: SafetyScoreEntity, delegate: SafetyBoardCellDelegate) {
        self.delegate = delegate
        containerView.backgroundColor = data.type.bg
        totalRecordLabel.textColor = data.type.color
        safetyLabel.textColor = data.type.color
        
        chartView.configure(width: 14.0, color: data.type.color, proportion: data.score, textFont: 24, textWeight: .heavy, textColor: data.type.color)
        
        strongScoreLabel.text = data.groups[.strong]?.count.stringValue
        weakScoreLabel.text = data.groups[.weak]?.count.stringValue
        reusedScoreLabel.text = data.groups[.reused]?.count.stringValue
        
        let countText = data.totalRecord > 1 ? Strings.totalRecordPlural : Strings.totalRecordSingular
        totalRecordLabel.text = String(format: countText, data.totalRecord)
    }
    
    @IBAction func safetyTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            delegate?.changeGroup(group: .strong)
        case 1:
            delegate?.changeGroup(group: .weak)
        case 2:
            delegate?.changeGroup(group: .reused)
        default:
            break
        }
    }
    
}


extension SafetyBoardCell {
    struct Strings {
        static let totalRecordSingular = "%d record_count_singular".localized
        static let totalRecordPlural = "%d record_count_plural".localized
        static let safetyScoreTitle = "safety_score_title".localized
        static let strongScoreTitle = "safety_strong_score_title".localized
        static let weakScoreTitle = "safety_weak_score_title".localized
        static let reusedScoreTitle = "safety_reused_score_title".localized
    }
}
