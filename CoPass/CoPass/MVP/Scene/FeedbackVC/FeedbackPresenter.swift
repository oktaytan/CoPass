//
//  FeedbackPresenter.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 15.07.2023.
//

import Foundation

protocol FeedbackPresenterProtocol: Presenter {
    func setFeedbackRating(rating: Double)
    func setFeedbackMessage(message: String)
    func sendFeedback()
}

final class FeedbackPresenter: FeedbackPresenterProtocol {
    
    private weak var ui: FeedbackUI?
    private let wireframe: FeedbackWireframeProtocol
    
    private var message: String = ""
    private var rating: Double = 0.0
    
    init(ui: FeedbackUI, wireframe: FeedbackWireframeProtocol) {
        self.ui = ui
        self.wireframe = wireframe
    }
    
    func viewDidLoad() {
        
    }
    
    func setFeedbackRating(rating: Double) {
        self.rating = rating
    }
    
    func setFeedbackMessage(message: String) {
        self.message = message
    }
    
    func sendFeedback() {
        let feedback = CoFeedback(message: message, rating: rating)
        print(feedback)
        wireframe.navigate(to: .dismiss(completion: {
            self.ui?.showAlert(title: nil, message: Strings.feedbackSuccessful, error: false)
        }))
    }
}


extension FeedbackPresenter {
    struct Strings {
        static let feedbackSuccessful = "feedback_send_successful".localized
    }
}
