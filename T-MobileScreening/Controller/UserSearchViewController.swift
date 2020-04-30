//
//  UserSearchViewController.swift
//  T-MobileScreening
//
//  Created by Tanay Kumar Roy on 4/30/20.
//  Copyright © 2020 Tanay Kumar Roy. All rights reserved.
//

import UIKit
import Kingfisher

class UserSearchViewController: UIViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var userTableView: UITableView!
    let cellIdentifier = "UserCell"
    var currentPageNumber = 1
    var nextPage = 0
    
    var viewModel = UserSearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userTableView.tableFooterView = UIView(frame: .zero)
        self.searchBar.delegate = self
    }
    
    func fetchUser(page: Int, isLoadingMore: Bool? = false) {
        if ConnectivityManager.isConnectedToInternet() {
            viewModel.getUserWithSearchkey(searchKey: searchBar.text ?? "", pageNumber: currentPageNumber) { user in
                if isLoadingMore ?? false {
                    self.viewModel.gitHubUserArray.append(contentsOf: user)
                } else {
                    self.viewModel.gitHubUserArray.removeAll()
                    self.viewModel.gitHubUserArray = user
                }
                self.userTableView.reloadData()
                self.searchBar.isLoading = false
            }
        } else {
            self.showErrorAlert(message: "No conncetivity.Please try later")
        }
    }
}

extension UserSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.gitHubUserArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        nextPage = viewModel.gitHubUserArray.count - 5
        if indexPath.row == nextPage {
            currentPageNumber = currentPageNumber + 1
            nextPage = viewModel.gitHubUserArray.count - 5
            self.fetchUser(page: currentPageNumber, isLoadingMore: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? UserTableViewCell else {
            return UITableViewCell()
        }
        cell.user = viewModel.gitHubUserArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let userDetailViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "UserDetailsViewController") as? UserDetailsViewController {
            userDetailViewController.userLoginName = viewModel.gitHubUserArray[indexPath.row].login
            userDetailViewController.gitHubUser = viewModel.gitHubUserArray[indexPath.row]
            self.navigationController?.pushViewController(userDetailViewController, animated: true)
        }
    }
}

extension UserSearchViewController: UISearchBarDelegate {
    
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
        self.fetchUser(page: currentPageNumber)
    }
}
