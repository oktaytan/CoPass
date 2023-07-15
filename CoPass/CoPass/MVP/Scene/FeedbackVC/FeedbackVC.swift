//
//  FeedbackVC.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 12.07.2023.
//

import UIKit
import Cosmos

final class FeedbackVC: BaseViewController {
    
    typealias Presenter = FeedbackPresenterProtocol
    var presenter: Presenter!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var textView: CoTextView!
    @IBOutlet weak var starRatingView: CosmosView!
    @IBOutlet weak var sendButton: CoButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        showIndicator = true
        titleLabel.text = Strings.title
        messageLabel.text = Strings.message
        
        sendButton.setTitle(Strings.sendButtonTitle, for: .normal)
        sendButton.type = .primary
        
        textView.configure(placeholder: Strings.placeholder)
        textView.stateClosure = { [weak self] type in
            switch type {
            case .updateUI(let data):
                self?.handleTextViewState(data)
            default:
                break
            }
        }
        
        starRatingView.settings.fillMode = .half
        starRatingView.didTouchCosmos = { [weak self] rating in
            self?.presenter.setFeedbackRating(rating: rating)
        }
        
        starRatingView.didFinishTouchingCosmos = { [weak self] rating in
            self?.presenter.setFeedbackRating(rating: rating)
        }
    }
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        presenter.sendFeedback()
    }
}


extension FeedbackVC: FeedbackUI {
    
}


extension FeedbackVC {
    private func handleTextViewState(_ event: CoTextView.UserInteractivity?) {
        switch event {
        case .shouldChangeCharacters(let text):
            presenter.setFeedbackMessage(message: text)
        default:
            break
        }
    }
}


extension FeedbackVC {
    struct Strings {
        static let title = "feedback_title".localized
        static let message = "feedback_message".localized
        static let placeholder = "feedback_textView_placeholder".localized
        static let sendButtonTitle = "feedback_send_button_title".localized
    }
}
