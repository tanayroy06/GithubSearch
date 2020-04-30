//
//  GHUserRepository.swift
//  T-MobileScreening
//
//  Created by Tanay Kumar Roy on 4/30/20.
//  Copyright © 2020 Tanay Kumar Roy. All rights reserved.
//

import Foundation

struct GHRepository {
    
    /// Repository Objects.
    var id: Int?
    var name: String?
    var html_url: String?
    var git_url: String?
    var stargazers_count: Int?
    var forks_count: Int?
    var description: String?
    
    /// Owner Objects.
    var login: String?
    var avatar_url: String?
    
}
