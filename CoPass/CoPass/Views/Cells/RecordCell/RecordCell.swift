//
//  RecordCell.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 4.07.2023.
//

import UIKit

protocol RecordCellDelegate: AnyObject {
    func copied(record: Record)
}

extension RecordCellDelegate {
    func copied(record: Record) {}
}

class RecordCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var platformLabel: UILabel!
    @IBOutlet weak var entryLabel: UILabel!
    
    weak var delegate: RecordCellDelegate?
    var record: Record?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        containerView.cornerRadius = AppConstants.appUIRadius
        iconImageView.cornerRadius = 10
    }
    
    func set(record: Record, delegate: RecordCellDelegate) {
        self.record = record
        self.delegate = delegate
        platformLabel.text = record.platform
        entryLabel.text = record.entry
    }
    
    @IBAction func copyTapped(_ sender: Any) {
        guard let record = self.record else { return }
        delegate?.copied(record: record)
    }
}
