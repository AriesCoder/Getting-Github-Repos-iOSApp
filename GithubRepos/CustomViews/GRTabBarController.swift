//
//  GRTabBarController.swift
//  GithubRepos
//
//  Created by Aries Lam on 1/19/23.
//

import UIKit

class GRTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemCyan
        viewControllers = [createSearchNavCon(), createFavoriteNavCon()]
    }
    
    func createSearchNavCon() -> UINavigationController{
        let searchVC = SearchVC()
        searchVC.title = "Search Github Repos"
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        return UINavigationController(rootViewController: searchVC)
    }
    
    
    func createFavoriteNavCon() -> UINavigationController{
        let bookmarksVC = BookmarksVC()
        bookmarksVC.title = "Favorite Github Repos"
        bookmarksVC.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)
        return UINavigationController(rootViewController: bookmarksVC)
    }
    


}
