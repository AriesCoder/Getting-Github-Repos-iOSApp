//
//  SortMenuVC.swift
//  GithubRepos
//
//  Created by Aries Lam on 2/10/23.
//

import Foundation
import UIKit

protocol SortMenuDelegate: AnyObject {
    
    func didSelectLanguage(with language: String)
}

class SortMenuVC: UIViewController{
  

    private var transparentView     : UIView!
    private var sortMenu            = UITableView()
    var languages                   = ["All"]

    let height: CGFloat             = 300
    weak var delegate               : SortMenuDelegate!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateSortMenuData(with repos: [Repo]) {
        
        var languageSet: Set<String> = []
        languages = ["All"]
        for repo in repos {
            languageSet.insert(repo.language ?? "No language added")
        }
        languages.append(contentsOf: Array(languageSet))
    }

    func configureTransparentView(superView: UIView) {

        guard let window = UIApplication.shared.keyWindow else {return}
        transparentView = UIView(frame: superView.bounds)
        window.addSubview(transparentView)
        configureSortMenu(window)
        transparentView.backgroundColor = UIColor(white: 0, alpha: 0.5)

        transparentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissSortMenu)))
        transparentView.alpha = 0

        let y = window.frame.height - height

        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
            self.transparentView.alpha = 1
            self.sortMenu.frame = CGRectMake(0, y, self.sortMenu.frame.width, self.sortMenu.frame.height)
        }
    }

    func configureSortMenu(_ window: UIWindow){

        sortMenu.delegate = self
        sortMenu.dataSource = self
        window.addSubview(sortMenu)
        sortMenu.reloadData()
        sortMenu.backgroundColor = .systemBackground
        sortMenu.translatesAutoresizingMaskIntoConstraints = false
        sortMenu.frame = CGRectMake(0, window.frame.height, window.frame.width, height)
    //register cell
        sortMenu.register(SortMenuCell.self, forCellReuseIdentifier: ReuseId.sortMenuCell)
        sortMenu.rowHeight = 40
        sortMenu.tableFooterView = UIView(frame: .zero)     //remove excess cells
        sortMenu.setContentOffset(.zero, animated: true)    //tableView go back to top

    }

    @objc func dismissSortMenu() {

        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) {
            self.transparentView.alpha = 0
            self.sortMenu.frame = CGRectMake(0, self.view.frame.height, self.sortMenu.frame.width, self.height)
        }

    }
    
}

extension SortMenuVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = sortMenu.dequeueReusableCell(withIdentifier: ReuseId.sortMenuCell, for: indexPath) as! SortMenuCell
        let language = languages[indexPath.row]
        cell.set(label: language)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let languageSelected = languages[indexPath.row]
        delegate.didSelectLanguage(with: languageSelected)
        dismissSortMenu()
        tableView.deselectRow(at: indexPath, animated: true) //deselect cell after selection
    }
}

