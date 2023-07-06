//
//  CoSectionTitleView.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 4.07.2023.
//

import UIKit

final class CoSectionTitleView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = .coText
        return titleLabel
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = .white
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(20)
        }
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
}
