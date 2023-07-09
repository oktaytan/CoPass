//
//  CoTextField.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 21.06.2023.
//

import UIKit
import SnapKit

final class CoTextField: UITextField {
    
    var padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    
    override var placeholder: String? {
        didSet {
            guard let placeholder = placeholder else { return }
            self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes:
                                                                [NSAttributedString.Key.foregroundColor: UIColor.coTextGray]
            )
        }
    }
    
    var errorMessage: String? {
        didSet {
            guard let errorMessage = self.errorMessage else {
                self.hideError()
                return
            }
            self.errorLabel.text = errorMessage
            self.showError()
        }
    }
    
    @IBInspectable
    var identifier: String = ""
    
    private lazy var secureIconBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "showIcon"), for: .normal)
        button.tintColor = .coTextGray
        button.addTarget(self, action: #selector(showHideSecureTextEntry), for: .touchUpInside)
        return button
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .coRed
        label.transform = CGAffineTransform(translationX: 0, y: -20)
        label.layer.opacity = 0.0
        label.accessibilityIdentifier = "error"
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        self.backgroundColor = .coBg
        self.borderStyle = .none
        self.cornerRadius = AppConstants.appUIRadius
        self.frame.size.height = 52.0
        self.textColor = .coText
        
        self.insertSubview(secureIconBtn, at: 0)
        secureIconBtn.snp.makeConstraints { make in
            make.width.height.equalTo(44.0)
            make.trailing.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
        }
        
        secureIconBtn.isHidden = !isSecureTextEntry
        secureIconBtn.isEnabled = isSecureTextEntry
        padding.right = isSecureTextEntry ? 60.0 : 16.0
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
}


extension CoTextField {
    private func showError() {
        guard self.errorMessage != nil else { return }
        self.addSubview(errorLabel)
        self.clipsToBounds = false
        
        errorLabel.snp.makeConstraints { make in
            make.width.equalTo(self.bounds.width)
            make.height.equalTo(18)
            make.top.equalTo(self.snp.bottom).offset(4)
            make.left.equalTo(self.snp.left).offset(16)
            make.right.equalTo(self.snp.right)
        }
        
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseIn, animations: { [weak self] in
            self?.errorLabel.transform = CGAffineTransform(translationX: 0, y: 0)
            self?.errorLabel.layer.opacity = 1.0
        }, completion: nil)
    }
    
    private func hideError() {
        guard let errorLabel = self.subviews.first(where: { $0.accessibilityIdentifier == "error" }) else { return }
        
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut) {
            errorLabel.layer.opacity = 0.0
            errorLabel.transform = CGAffineTransform(translationX: 0, y: -17)
        } completion: { _ in
            errorLabel.removeFromSuperview()
            self.clipsToBounds = true
        }
    }
    
    @objc
    private func showHideSecureTextEntry() {
        isSecureTextEntry = !isSecureTextEntry
        secureIconBtn.setImage(UIImage(named: isSecureTextEntry ? "showIcon" : "hideIcon"), for: .normal)
    }
}
