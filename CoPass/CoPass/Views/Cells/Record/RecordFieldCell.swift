//
//  RecordFieldCell.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 9.07.2023.
//

import UIKit

protocol RecordFieldCellDelegate: AnyObject {
    func changeField(type: CoRecordFieldType)
}

extension RecordFieldCellDelegate {
    func changeField(type: CoRecordFieldType) {}
}

class RecordFieldCell: UITableViewCell {

    @IBOutlet weak var fieldsStackView: UIStackView!
    weak var delegate: RecordFieldCellDelegate?
    private var category: CoCategory?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        fieldsStackView.arrangedSubviews.forEach { view in
            guard let textField = view as? CoTextField else { return }
            textField.delegate = self
        }
    }
    
    func set(record: RecordEntity, delegate: RecordFieldCellDelegate) {
        self.delegate = delegate
        self.category = record.category
        
        record.category.recordFields.enumerated().forEach { (index, field) in
            fieldsStackView.arrangedSubviews.forEach { view in
                guard let textField = view as? CoTextField else { return }
                if textField.tag == index {
                    textField.placeholder = field
                }
                
                view.setFromAnimation(index: textField.tag)
                
                switch textField.identifier {
                case "platform":
                    textField.text = record.platform
                case "entry":
                    textField.text = record.entry
                case "password":
                    textField.text = record.password
                default:
                    break
                }
            }
        }
    }
    
    func showErrorMessage(message: String, identifier: String) {
        fieldsStackView.arrangedSubviews.forEach { view in
            guard let textField = view as? CoTextField, textField.identifier == identifier else { return }
            textField.errorMessage = message
        }
    }
}


extension RecordFieldCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string),
                let coTextField = textField as? CoTextField,
                let fieldType = CoRecordFieldType(identifier: coTextField.identifier, text: newText) else { return false }
        
        if newText != "" {
            coTextField.errorMessage = nil
        }
        
        delegate?.changeField(type: fieldType)
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}


extension RecordFieldCell {
    struct Strings {
        static let title = "register_title".localized
        static let subtitle = "register_subtitle".localized
        static let username = "register_username".localized
        static let masterPassword = "register_master_password".localized
        static let reMasterPassword = "register_remaster_password".localized
        static let registerAction = "register_action".localized
        static let registerSuccess = "register_success".localized
        static let registerFailure = "register_failure".localized
        
        struct Errors {
            static let emptyField = "register_empty_field".localized
            static let allFieldFill = "register_all_field_should_fill".localized
            static let invalidUsername = "register_invalid_username".localized
            static let invalidMasterPassword = "register_invalid_master_password".localized
            static let invalid_ReMasterPassword = "register_invalid_remaster_password".localized
        }
    }
}
