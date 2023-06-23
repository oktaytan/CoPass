//
//  CoOneTimeCodeTextField.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 24.06.2023.
//

import UIKit

public class OneTimeCodeTextField: UITextField {
    
    // MARK: UI Components
    public var digitLabels = [UILabel]()
    
    // MARK: Delegates
    public lazy var oneTimeCodeDelegate = OneTimeCodeTextFieldDelegate(oneTimeCodeTextField: self)
    
    // MARK: Properties
    private var isConfigured = false
    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(becomeFirstResponder))
        return recognizer
    }()
    
    // MARK: Completions
    public var didReceiveCode: ((String) -> Void)?
    
    // MARK: Customisations
    /// Needs to be called after `configure()`.
    /// Default value: `.secondarySystemBackground`
    public var codeBackgroundColor: UIColor = .coBg {
        didSet {
            digitLabels.forEach({ $0.backgroundColor = codeBackgroundColor })
        }
    }
    
    /// Needs to be called after `configure()`.
    /// Default value: `.label`
    public var codeTextColor: UIColor = .coPurple {
        didSet {
            digitLabels.forEach({ $0.textColor = codeTextColor })
        }
    }
    
    /// Needs to be called after `configure()`.
    /// Default value: `.systemFont(ofSize: 24)`
    public var codeFont: UIFont = .systemFont(ofSize: 32, weight: .bold) {
        didSet {
            digitLabels.forEach({ $0.font = codeFont })
        }
    }
    
    /// Needs to be called after `configure()`.
    /// Default value: 0.8
    public var codeMinimumScaleFactor: CGFloat = 1 {
        didSet {
            digitLabels.forEach({ $0.minimumScaleFactor = codeMinimumScaleFactor })
        }
    }
    
    /// Needs to be called after `configure()`.
    /// Default value: 8
    public var codeCornerRadius: CGFloat = AppConstants.appUIRadius {
        didSet {
            digitLabels.forEach({ $0.layer.cornerRadius = codeCornerRadius })
        }
    }
    
    /// Needs to be called after `configure()`.
    /// Default value: `.continuous`
    public var codeCornerCurve: CALayerCornerCurve = .continuous {
        didSet {
            digitLabels.forEach({ $0.layer.cornerCurve = codeCornerCurve })
        }
    }
    
    /// Needs to be called after `configure()`.
    /// Default value: 0
    public var codeBorderWidth: CGFloat = 0 {
        didSet {
            digitLabels.forEach({ $0.layer.borderWidth = codeBorderWidth })
        }
    }
    
    /// Needs to be called after `configure()`.
    /// Default value: `.none`
    public var codeBorderColor: UIColor? = .none {
        didSet {
            digitLabels.forEach({ $0.layer.borderColor = codeBorderColor?.cgColor })
        }
    }
        
    // MARK: Configuration
    public func configure(withSlotCount slotCount: Int = 6, andSpacing spacing: CGFloat = 8) {
        guard isConfigured == false else { return }
        isConfigured = true
        configureTextField()
        
        let slotsStackView = generateSlotsStackView(with: slotCount, spacing: spacing)
        addSubview(slotsStackView)
        addGestureRecognizer(tapGestureRecognizer)
        
        NSLayoutConstraint.activate([
            slotsStackView.topAnchor.constraint(equalTo: topAnchor),
            slotsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            slotsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            slotsStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func configureTextField() {
        tintColor = .clear
        textColor = .clear
        layer.borderWidth = 0
        borderStyle = .none
        keyboardType = .numberPad
        textContentType = .oneTimeCode
        isSecureTextEntry = true
        
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        delegate = oneTimeCodeDelegate
        
        becomeFirstResponder()
    }
    
    private func generateSlotsStackView(with count: Int, spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = spacing
        
        for _ in 0..<count {
            let slotLabel = generateSlotLabel()
            stackView.addArrangedSubview(slotLabel)
            digitLabels.append(slotLabel)
        }
        
        return stackView
    }
    
    private func generateSlotLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.textAlignment = .center
        label.font = codeFont
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = codeMinimumScaleFactor
        label.textColor = codeTextColor
        label.backgroundColor = codeBackgroundColor
        
        label.layer.masksToBounds = true
        label.layer.cornerRadius = codeCornerRadius
        label.layer.cornerCurve = codeCornerCurve
        
        label.layer.borderWidth = codeBorderWidth
        label.layer.borderColor = codeBorderColor?.cgColor
        
        return label
    }
    
    @objc
    private func textDidChange() {
        guard let code = text, code.count <= digitLabels.count else { return }
        
        for i in 0 ..< digitLabels.count {
            let currentLabel = digitLabels[i]
            
            if i < code.count {
                currentLabel.text = "٭"
            } else {
                currentLabel.text?.removeAll()
            }
        }
        
        if code.count == digitLabels.count { didReceiveCode?(code) }
    }
    
    public func clear() {
        guard isConfigured == true else { return }
        digitLabels.forEach({ $0.text = "" })
        text = ""
    }
}


extension OneTimeCodeTextField {
    public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        false
    }
    
    public override func caretRect(for position: UITextPosition) -> CGRect {
        .zero
    }
    
    public override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        []
    }
}


public class OneTimeCodeTextFieldDelegate: NSObject, UITextFieldDelegate {

    public var allowedCharacters: CharacterSet = .decimalDigits

    let oneTimeCodeTextField: OneTimeCodeTextField
    
    init(oneTimeCodeTextField: OneTimeCodeTextField) {
        self.oneTimeCodeTextField = oneTimeCodeTextField
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard allowedCharacters.isSuperset(of: CharacterSet(charactersIn: string)),
              let characterCount = textField.text?.count else { return false }
        return characterCount < oneTimeCodeTextField.digitLabels.count || string == ""
    }
}
