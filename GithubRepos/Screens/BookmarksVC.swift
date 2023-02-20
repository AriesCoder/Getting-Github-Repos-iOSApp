//
//  BookmarksVC.swift
//  GithubRepos
//
//  Created by Aries Lam on 1/19/23.
//

import UIKit

class BookmarksVC: UIViewController {
    
    enum BookmarkSection{
        case main
    }
    
    var tableView   = UITableView()
//    var originRepos = [Repo]()
    var repos       = [Repo]()
//    let sortMenuVC  = SortMenuVC()
    var dataSource  : UITableViewDiffableDataSource<BookmarkSection, Repo>!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureTableView()
//        sortMenuVC.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(sortBtnTapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getBookmarkedRepo()
    }
    
    @objc func sortBtnTapped() {
        print("sort btn tapped")
//        guard !repos.isEmpty else {return}
//        sortMenuVC.configureTransparentView(superView: view.self)
    }

    func getBookmarkedRepo(){
        PersistenceManager.retrieveBookmarks { [weak self] result in
            guard let self = self else{ return }
            
            switch result {
            case .success(let repoArr):
                if repoArr.isEmpty{
                    self.showEmptyStateView(with: "Bookmark is empty", img: Icons.bookmark!, in: self.view)
                } else {
                    self.repos.append(contentsOf: repoArr)
//                    self.originRepos.append(contentsOf: repoArr)

                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else{return}
                        self.view.bringSubviewToFront(self.tableView)
                        self.updateData(repos: repoArr)
                    }
//                    self.sortMenuVC.updateSortMenuData(with: self.originRepos)
                }
                
            case .failure(let error):
                self.presentGRAlert(title: "Something went wrong", message: error.rawValue)
            }
        }
    }

    func configureTableView() {
        
        view.addSubview(tableView)
        tableView.delegate      = self
        configureDiffableDataSource()
        tableView.rowHeight     = 60
        tableView.frame         = view.bounds
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(BookmarkCell.self, forCellReuseIdentifier: BookmarkCell.reuseID)
        
    }
//MARK: - DataSource
    func configureDiffableDataSource() {
        dataSource = UITableViewDiffableDataSource<BookmarkSection, Repo>(tableView: tableView, cellProvider: { collectionView, indexPath, repo in
            let cell = self.tableView.dequeueReusableCell(withIdentifier: BookmarkCell.reuseID, for: indexPath) as! BookmarkCell
            cell.set(repo: repo)
            
            return cell
        })
    }
    
    func updateData(repos: [Repo]) {
        var snapShot = NSDiffableDataSourceSnapshot<BookmarkSection, Repo>()
        snapShot.appendSections([.main])
        snapShot.appendItems(repos)
        DispatchQueue.main.async {
            self.dataSource.apply(snapShot, animatingDifferences: true)
        }
    }
    
}

extension BookmarksVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //send repo info to next view
        let repo = repos[indexPath.row]
        let destVC = RepoDetailVC(repo: repo)
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            guard let self = self else { return }
            
            let repo = self.repos[indexPath.row]
            PersistenceManager.updateData(with: repo, actionType: .remove) { error in
                if let error = error {
                    self.presentGRAlert(title: "Unable to remove", message: error.rawValue)
                } else {
                    self.repos.remove(at: indexPath.row)
//                    self.originRepos.append(contentsOf: self.repos)
                    self.updateData(repos: self.repos)
                    if self.repos.isEmpty{
                        self.showEmptyStateView(with: "Bookmark is empty", img: Icons.bookmark!, in: self.view)
                    }
                   //set language array for sortMenu
//                    self.sortMenuVC.updateSortMenuData(with: self.repos)
                    
                    completion(true)
                }
            }
        }
        
        deleteAction.backgroundColor = .red
        deleteAction.image = UIImage(systemName: "trash")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

}

//extension BookmarksVC: SortMenuDelegate {
//
//    func didSelectLanguage(with language: String) {
//
//        //sort the reposTable with the selected language
//        if language == "All" {
//            updateData(repos: originRepos)
//            repos = originRepos
//            tableView.setEditing(true, animated: true)
//        }
//        else if language == "No language added" {
//            repos = originRepos.filter({ repo in
//                repo.language == nil
//            })
//            updateData(repos: repos)
////            tableView.setEditing(false, animated: true)
//        }
//        else {
//            repos = originRepos.filter({ repo in
//                repo.language == language
//            })
//            updateData(repos: repos)
////            tableView.setEditing(false, animated: true)
//        }
//    }
//}
        
