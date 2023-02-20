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
        UITabBar.appearance().tintColor         = .systemCyan
        UITabBar.appearance().backgroundColor   = .systemBackground
        viewControllers = [createSearchNavCon(), createFavoriteNavCon()]
    }
    
    func createSearchNavCon() -> UINavigationController{
        //customize UItabbar item
        let repo = UITabBarItem(title: "Repository", image: UIImage(systemName: "book.closed"), selectedImage: nil)
        let searchVC = SearchVC()
        searchVC.title = "Search Github Repos"
        searchVC.tabBarItem = repo
        return UINavigationController(rootViewController: searchVC)
    }
    
    
    func createFavoriteNavCon() -> UINavigationController{
        let bookmarksVC = BookmarksVC()
        bookmarksVC.title = "Bookmarks"
        bookmarksVC.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)
        return UINavigationController(rootViewController: bookmarksVC)
    }
    


}
