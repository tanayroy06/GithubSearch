//
//  UserTableViewCell.swift
//  T-MobileScreening
//
//  Created by Tanay Kumar Roy on 4/30/20.
//  Copyright © 2020 Tanay Kumar Roy. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet var profileIconImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var totalRepositoryCountLabel: UILabel!
    
    var user: GHUser? {
        didSet {
            if let gitHubUser = user {
                profileIconImageView.kf.setImage(with: URL(string: gitHubUser.avatar_url ?? ""),placeholder: UIImage(named: "placeholderImage"),options: nil)
                userNameLabel.text = gitHubUser.login
                totalRepositoryCountLabel.text = String(gitHubUser.forks_count ?? 0)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
