//
//  UserDetailTableViewCell.swift
//  T-MobileScreening
//
//  Created by Tanay Kumar Roy on 4/30/20.
//  Copyright © 2020 Tanay Kumar Roy. All rights reserved.
//

import UIKit

class UserDetailTableViewCell: UITableViewCell {

    @IBOutlet var repoNameLabel: UILabel!
    @IBOutlet var totalForksLabel: UILabel!
    @IBOutlet var totalStarLabel: UILabel!
    
    var userRepo: GHRepository? {
        didSet {
            if let gitHubUserRepo = userRepo {
                repoNameLabel.text = gitHubUserRepo.name
                totalForksLabel.text = String(gitHubUserRepo.forks_count ?? 0) + " Forks"
                totalStarLabel.text = String(gitHubUserRepo.stargazers_count ?? 0) + " Stars"
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
