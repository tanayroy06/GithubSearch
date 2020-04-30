//
//  GitHubAPI.swift
//  T-MobileScreening
//
//  Created by Tanay Kumar Roy on 4/30/20.
//  Copyright © 2020 Tanay Kumar Roy. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum SourceURL: String {
    //case RepositoryURL = "https://api.github.com/search/repositories?q=language:Swift&sort=stars"
    // case RepositoryURL = "https://api.github.com/users/Awesome-HarmonyOS/repos?q=awe"
    case RepositoryURL = "https://api.github.com/users"
    case UserSearchURL = "https://api.github.com/search/users"
}

class GitHubAPI {
    
    ///Network API Calling
    private func requestGitHubSearchResultJSONFrom(url: String, pageNumber: Int?, completionHandler: @escaping ((JSON) -> ())) {
        
        var pageParameter:[String: Any] = [:]
        
        if pageNumber != nil {
            pageParameter = ["page": pageNumber ?? 1]
        }
        
        AF.request(url, method: .get, parameters: pageParameter).response { response in
            switch response.result {
            case .success(let value):
                let data = JSON(value!)
                completionHandler(data)
            case .failure(let error):
                // error handling
                print("Error", error)
                let data = JSON([:])
                completionHandler(data)
                break
            }
        }
    }
    
    private func requestUserInfo(url: String, completionHandler: @escaping ((JSON) -> ())) {
        AF.request(url, method: .get).response { response in
            switch response.result {
            case .success(let value):
                let data = JSON(value!)
                completionHandler(data)
            case .failure(let error):
                print("Error", error)
                let data = JSON([:])
                completionHandler(data)
                break
            }
        }
    }
    
    ///Fetching  User Repository
    
    func fetchRepositoryDataFrom(url: SourceURL, userName: String, searchKey: String, pageNumber:Int?, completionHandler: @escaping (([GHRepository]) -> ()))  {
        let url = url.rawValue + "/\(userName)/repos?q=\(searchKey)"
        print(url)
        requestGitHubSearchResultJSONFrom(url: url, pageNumber: pageNumber) { json in
            let model = self.parseRepositoryDataFrom(json: json)
            completionHandler(model)
        }
    }
    
    private func parseRepositoryDataFrom(json: JSON) -> [GHRepository] {
        var repository = GHRepository()
        var repositoryArray = [GHRepository]()
        
        if let jsonItemsCounter = json.array?.count {
            for item in 0..<jsonItemsCounter {
                repository.name = json[item]["name"].stringValue
                repository.description = json[item]["description"].stringValue
                repository.stargazers_count = json[item]["stargazers_count"].intValue
                repository.forks_count = json[item]["forks_count"].intValue
                repository.html_url = json[item]["html_url"].stringValue
                repository.git_url = json[item]["git_url"].stringValue
                
                /// Owner
                repository.login = json["items"][item]["login"].stringValue
                repository.avatar_url = json["items"][item]["avatar_url"].stringValue
                
                repositoryArray.append(repository)
            }
        }
        
        return repositoryArray
    }
    
    ///Fetching Search User
    
    func fetchUserDataFrom(url: SourceURL, searchKey: String, pageNumber: Int?, completionHandler: @escaping (([GHUser]) -> ()))  {
        requestGitHubSearchResultJSONFrom(url: url.rawValue + "?q=\(searchKey)", pageNumber: pageNumber) { json in
            let model = self.parseUserDataFrom(json: json)
            completionHandler(model)
        }
    }
    
    private func parseUserDataFrom(json: JSON) -> [GHUser] {
        var user = GHUser()
        var userArray = [GHUser]()
        let jsonItems = json["items"].array
        if let jsonItemsCounter = json["items"].array?.count {
            for item in 0..<jsonItemsCounter {
                /// User Request
                user.login = jsonItems?[item]["login"].stringValue
                user.avatar_url = jsonItems?[item]["avatar_url"].stringValue
                userArray.append(user)
            }
        }
        return userArray
    }
    
    ///Fetching User Info
    func fetchUserInfoDataFrom(url: SourceURL, userName: String, completionHandler: @escaping ((GHUser) -> ()))  {
        requestUserInfo(url: url.rawValue + "/\(userName)") { json in
            let model = self.parseUserInfoDataFrom(json: json)
            completionHandler(model)
        }
    }
    
    private func parseUserInfoDataFrom(json: JSON) -> GHUser {
        var userInfo = GHUser()
        
        /// User Info Request
        userInfo.userFullName = json["name"].stringValue
        userInfo.userEmail = json["email"].stringValue
        userInfo.userLocation = json["location"].stringValue
        userInfo.userJoiningDate = json["created_at"].stringValue
        userInfo.followersCount = json["followers"].intValue
        userInfo.followingCount = json["following"].intValue
        
        return userInfo
    }
}
