//
//  UserDetailsViewController.swift
//  T-MobileScreening
//
//  Created by Tanay Kumar Roy on 4/30/20.
//  Copyright © 2020 Tanay Kumar Roy. All rights reserved.
//

import UIKit
import Kingfisher

class UserDetailsViewController: UIViewController {
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var joiningDateLabel: UILabel!
    @IBOutlet var totalFollowerCountLabel: UILabel!
    @IBOutlet var totalFollowingCountLabel: UILabel!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var repoTableView: UITableView!
    
    let cellIdentifier = "UserDetailCell"
    var viewModel = UserDetailViewModel()
    var userInfoViewModel = UserSearchViewModel()
    
    var gitHubUser: GHUser?
    var userLoginName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        repoTableView.tableFooterView = UIView(frame: .zero)
        self.searchBar.delegate = self
        self.updateUserInfo()
        //self.fetchUserRepo()
    }
    
    func fetchUserRepo(searchKey: String) {
        if ConnectivityManager.isConnectedToInternet() {
            viewModel.getUserRepositoryWithUser(userName: userLoginName ?? "", searchKey: searchKey) { user in
                self.viewModel.gitHubUserRepoArray = user
                self.repoTableView.reloadData()
                self.searchBar.isLoading = false
            }
        } else {
            self.showErrorAlert(message: "No conncetivity.Please try later")
            
        }
    }
    
    private func updateUserInfo() {
        if ConnectivityManager.isConnectedToInternet() {
            userInfoViewModel.getUserInfo(userName: userLoginName ?? "") { user in
                self.userInfoViewModel.gitHubUserInfo = user
                self.avatarImageView.kf.setImage(with: URL(string: self.gitHubUser?.avatar_url ?? ""),placeholder: UIImage(named: "placeholderImage"),options: nil)
                self.userNameLabel.text = self.userInfoViewModel.gitHubUserInfo.userFullName
                self.emailLabel.text = self.userInfoViewModel.gitHubUserInfo.userEmail
                self.locationLabel.text = self.userInfoViewModel.gitHubUserInfo.userLocation
                self.joiningDateLabel.text = self.convertStringToDateAndToString(dateString: self.userInfoViewModel.gitHubUserInfo.userJoiningDate ?? "")
                self.totalFollowerCountLabel.text = String(self.userInfoViewModel.gitHubUserInfo.followersCount ?? 0) + " followers"
                self.totalFollowingCountLabel.text = "following " + String(self.userInfoViewModel.gitHubUserInfo.followingCount ?? 0)
            }
        } else {
            self.showErrorAlert(message: "No conncetivity.Please try later")
        }
    }
    
    private func convertStringToDateAndToString(dateString: String) -> String{
        let isoDate = "2016-04-14T10:44:00+0000" //2007-10-20T05:24:19Z
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:isoDate)!
        dateFormatter.dateStyle = .long
        return dateFormatter.string(from: date)
    }
}

extension UserDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.gitHubUserRepoArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? UserDetailTableViewCell else {
            return UITableViewCell()
        }
        cell.userRepo = viewModel.gitHubUserRepoArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let url = URL(string: viewModel.gitHubUserRepoArray[indexPath.row].html_url ?? "") {
            if UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
}

extension UserDetailsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload(_:)), object: searchBar)
        perform(#selector(self.reload(_:)), with: searchBar, afterDelay: 0.75)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    @objc func reload(_ searchBar: UISearchBar) {
        /*
         guard let query = searchBar.text, query.trimmingCharacters(in: .whitespaces) != "" else {
         print("nothing to search")
         return
         }*/
        searchBar.isLoading = true
        self.fetchUserRepo(searchKey: searchBar.text ?? "")
    }
}
