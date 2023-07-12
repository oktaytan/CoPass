//
//  ProfileUserCell.swift
//  CoPass
//
//  Created by Oktay Tanrıkulu on 11.07.2023.
//

import UIKit

protocol ProfileUserCellDelegate: AnyObject {
    func action(_ event: ProfileUserCell.UserActionEvent)
}

extension ProfileUserCellDelegate {
    func action(_ event: ProfileUserCell.UserActionEvent) {}
}

class ProfileUserCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: CoCircularImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var lastLoginLabel: UILabel!
    
    weak var delegate: ProfileUserCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(with user: User, delegate: ProfileUserCellDelegate) {
        self.delegate = delegate
        
        if let imageData = user.image?.decodedData() {
            avatarImageView.image = UIImage(data: imageData)
        } else {
            avatarImageView.image = UIImage(named: "avatar_placeholder")
        }
        
        usernameLabel.text = user.username.capitalized
        
        let dateFormatter = DateFormatter(format: "dd/MM/YYYY - HH:mm")
        let date = user.lastLogin?.toString(dateFormatter: dateFormatter) ?? ""
        lastLoginLabel.text = String(format: "profile_last_login_date".localized, date)
    }
    
    @IBAction func editBtnTapped(_ sender: Any) {
        delegate?.action(.editTapped)
    }
}


extension ProfileUserCell {
    struct Strings {
        static let lastLogin = "profile_last_login_date".localized
    }
    
    enum UserActionEvent {
        case editTapped
    }
}
