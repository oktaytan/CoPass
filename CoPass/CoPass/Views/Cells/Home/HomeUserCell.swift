//
//  HomeUserCell.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 30.06.2023.
//

import UIKit

protocol HomeUserCellDelegate: AnyObject {
    func action(_ event: HomeUserCell.UserActionEvent)
}

extension HomeUserCellDelegate {
    func action(_ event: HomeUserCell.UserActionEvent) {}
}

class HomeUserCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: CoCircularImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var notifyView: CoBadgeView!
    
    weak var delegate: HomeUserCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        welcomeLabel.text = Strings.welcome
        notifyView.configure(image: "notifyIcon", badgeValue: 0, hasAction: true)
        
        notifyView.action = { [weak self] in
            self?.delegate?.action(.notifyTapped)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(setNewNotificationCount(_:)), name: .notificationCount, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setup(user: User, delegate: HomeUserCellDelegate) {
        self.delegate = delegate
        
        if let imageData = user.image {
            avatarImageView.image = UIImage(data: imageData)
        } else {
            avatarImageView.image = UIImage(named: "avatar_placeholder")
        }
        
        usernameLabel.text = user.username.capitalized
    }
    
    @IBAction func avatarTapped(_ sender: Any) {
        delegate?.action(.avatarTapped)
    }
    
    @objc func setNewNotificationCount(_ notification: Notification) {
        if let count = notification.userInfo?[AppConstants.NOTIFICATION_COUNT] as? Int {
            notifyView.setBadge(with: count)
        }
    }
}

extension HomeUserCell {
    struct Strings {
        static let welcome = "home_welcome".localized
    }
    
    enum UserActionEvent {
        case avatarTapped, notifyTapped
    }
}
