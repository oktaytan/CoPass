//
//  CoSearchField.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 5.07.2023.
//

import UIKit

protocol CoSearchFieldProtocol {
    var stateClosure: ((ObservationType<CoSearchField.UserInteractivity, CoError>) -> ())? { get set }
    func setupUI()
}

class CoSearchField: UITextField, CoSearchFieldProtocol {
    
    var stateClosure: ((ObservationType<UserInteractivity, CoError>) -> ())?
    let padding = UIEdgeInsets(top: 0, left: 44, bottom: 0, right: 55)
    
    lazy var searchIcon: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "searchIcon")!.withRenderingMode(.alwaysOriginal)
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.changeClearImage()
    }
    
    func setupUI() {
        self.delegate = self
        self.cornerRadius = AppConstants.appUIRadius
        self.backgroundColor = .coBg
        self.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        self.textColor = .coText
        self.placeholder = "store_search_place_holder".localized
        
        let placeholderAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.coTextGray,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .regular)
        ]
        
        self.attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: placeholderAttributes)
        self.clearButtonMode = .whileEditing
        
        self.addSubview(searchIcon)
        self.searchIcon.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.left.equalTo(self).offset(17)
            make.centerY.equalTo(self)
        }
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: self.frame.size.width - 40, y: 16, width: 20, height: 20)
    }
}


extension CoSearchField {
    enum UserInteractivity {
        case didBeginEditing(_ textField: UITextField)
        case shouldClear(_ textField: UITextField)
        case shouldReturn(_ textField: UITextField)
        case didChangeSelection(_ newText: String)
        case shouldChangeCharacters(_ newText: String)
    }
}


// MARK: - UITextFieldDelegate
extension CoSearchField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        stateClosure?(.updateUI(data: .didBeginEditing(textField)))
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
        self.text = nil
        stateClosure?(.updateUI(data: .shouldClear(textField)))
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
        stateClosure?(.updateUI(data: .shouldReturn(textField)))
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let newText = self.text, newText.count > 0 else {
            return
        }
        stateClosure?(.updateUI(data: .didChangeSelection(newText)))
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return false }
        stateClosure?(.updateUI(data: .shouldChangeCharacters(newText)))
        return true
    }
}

extension CoSearchField {
    private func changeClearImage() {
        for view in subviews {
            if view is UIButton {
                let button = view as! UIButton
                if let newImage = UIImage(named: "closeIcon") {
                    button.setImage(newImage, for: .normal)
                    button.setImage(newImage, for: .highlighted)
                }
            }
        }
    }
}
