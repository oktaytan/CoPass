//
//  CoTextView.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 15.07.2023.
//

import UIKit
import SnapKit

protocol CoTextViewProtocol {
    var stateClosure: ((ObservationType<CoTextView.UserInteractivity, CoError>) -> ())? { get set }
    func setupUI()
}

final class CoTextView: UITextView, CoTextViewProtocol {
    
    var stateClosure: ((ObservationType<UserInteractivity, CoError>) -> ())?
    
    lazy var placeholder: UILabel = {
        let label = UILabel()
        label.textColor = .coTextGray
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        delegate = self
        backgroundColor = .coBg
        cornerRadius = AppConstants.appUIRadius
        font = .systemFont(ofSize: 12, weight: .medium)
        textColor = .coText
        contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        addSubview(placeholder)
        placeholder.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview()
        }
    }
    
    func configure(placeholder: String) {
        self.placeholder.text = placeholder
    }
}


extension CoTextView {
    enum UserInteractivity {
        case shouldChangeCharacters(_ newText: String)
    }
}


extension CoTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.placeholder.isHidden = true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let newText = (textView.text as NSString?)?.replacingCharacters(in: range, with: text) else { return false }
        
        self.placeholder.isHidden = !newText.isEmpty
        
        stateClosure?(.updateUI(data: .shouldChangeCharacters(newText)))
        return true
    }
}
