//
//  UserSearchViewModel.swift
//  T-MobileScreening
//
//  Created by Tanay Kumar Roy on 4/30/20.
//  Copyright © 2020 Tanay Kumar Roy. All rights reserved.
//

import Foundation

class UserSearchViewModel {
    var gitHubUserArray = [GHUser]()
    var gitHubUserInfo = GHUser()
    
    func getUserWithSearchkey(searchKey: String, pageNumber: Int, completionHandler: @escaping (([GHUser]) -> ()))  {
        let api = GitHubAPI()
        api.fetchUserDataFrom(url: .UserSearchURL, searchKey: searchKey, pageNumber: pageNumber) { data in
            completionHandler(data)
        }
    }
    
    func getUserInfo(userName: String, completionHandler: @escaping ((GHUser) -> ()))  {
        let api = GitHubAPI()
        api.fetchUserInfoDataFrom(url: .RepositoryURL, userName: userName) { data in
            completionHandler(data)
        }
    }
}
