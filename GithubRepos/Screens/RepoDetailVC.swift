//
//  RepoDetailVC.swift
//  GithubRepos
//
//  Created by Aries Lam on 2/13/23.
//

import UIKit

class RepoDetailVC: UIViewController {
    
    enum Section {
        case main
    }
    
    enum TableSection{
        case main
    }
    
    let headerView              = UIView()
    var contributorCollection   : UICollectionView!
    let commitTable             = UITableView()
    
    var dataSource              : UICollectionViewDiffableDataSource<Section, Contributor>!
    var tableDataSource         : UITableViewDiffableDataSource<TableSection, Commit>!
    
    var contributors            = [Contributor]()
    var commits                 = [Commit]()
    var repo                    : Repo!
    var contributor             : Contributor!
    let contributorLabel        = GRTitleLabel(textAlighment: .center, fontSize: 20)
    
    init(repo: Repo) {
        super.init(nibName: nil, bundle: nil)
        self.repo = repo
        contributorLabel.text = "Contributor(s)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bookmark.fill"), style: .plain, target: self, action: #selector(addBtnTapped))
        
        getContributor(of: repo)
        getCommits(of: repo)
        configureHeaderView()
        configureCollectionView()
        configureTableView()
        layoutUIs()
    }

//MARK: - Configure views
    func configureCollectionView() {
    
        contributorCollection = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnCollectionViewLayout(view: view))
        view.addSubview(contributorCollection)
        view.addSubview(contributorLabel)
        contributorCollection.delegate          = self
        contributorCollection.register(ContributorCell.self, forCellWithReuseIdentifier: ContributorCell.reuseID)
        configureDiffableDataSource()
    }
    
    func configureTableView(){
        
        view.addSubview(commitTable)
        commitTable.frame       = view.bounds
        commitTable.rowHeight   = 100
        commitTable.delegate    = self
        commitTable.tableFooterView  = UIView(frame: .zero)
        configureTableDataSource()
        commitTable.register(CommitCell.self, forCellReuseIdentifier: CommitCell.reuseID)
        
    }

//MARK: - fetching data
    func getContributor(of repo: Repo) {
        
        Task{
            do{
                let contributors = try await NetworkManager().getContributor(with: repo.contributorsUrl)
                    self.contributors.append(contentsOf: contributors)
                    DispatchQueue.main.async {
                        self.view.bringSubviewToFront(self.contributorCollection)
                        self.updateData(contributors: self.contributors)
                    }
                } catch {
                if let _ = error as? GRError {
                    emptyRepoDetailView()
                }else{
                    presentDefaultError()
                }
            }
        }
    }
    
    func getCommits(of repo: Repo) {
        
        Task{
            do{
                let commits = try await NetworkManager().getCommits(with: repo.commitsUrl)
                self.commits.append(contentsOf: commits)
                DispatchQueue.main.async {
                    self.view.bringSubviewToFront(self.commitTable)
                    self.updateData(commits: self.commits)
                }
            } catch {
                if let grErr = error as? GRError {
                    presentGRAlert(title: "Something went wrong", message: grErr.rawValue)
                } else {
                    presentDefaultError()
                }
            }
        }
    }
    
//MARK: - add repo ro Bookmark
    
    @objc func addBtnTapped() {
        PersistenceManager.updateData(with: repo, actionType: .add) { [weak self] error in
            guard let self = self else {return}
            
            guard let error = error else {
                self.presentGRAlert(title: "Success!", message: "This repo is bookmarked")
                return
            }
            self.presentGRAlert(title: "Something went wrong", message: error.rawValue)
        }
        
    }
    
//MARK: - empty view
    func emptyRepoDetailView() {
        let msg = "Sorry! This repository is empty"
        let logo = Icons.repoImg
        let emptyRepoView = GREmptyStateView(message: msg, img: logo!)
        emptyRepoView.frame = view.bounds
        view.addSubview(emptyRepoView)
    }
    
//MARK: - DataDiffableSource
    func configureDiffableDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Contributor>(collectionView: contributorCollection, cellProvider: { collectionView, indexPath, contributor in
            let cell = self.contributorCollection.dequeueReusableCell(withReuseIdentifier: ContributorCell.reuseID, for: indexPath) as! ContributorCell
            cell.set(contributor: contributor)
            return cell
        })
    }
    
    func configureTableDataSource() {
        tableDataSource = UITableViewDiffableDataSource<TableSection, Commit>(tableView: commitTable, cellProvider: { tableView, indexPath, commit in
            let cell = self.commitTable.dequeueReusableCell(withIdentifier: CommitCell.reuseID, for: indexPath) as! CommitCell
            cell.set(repCommit: commit)
            return cell
        })
    }
    
//MARK: - Snapshot
    func updateData(contributors: [Contributor]) {
        
        var snapShot = NSDiffableDataSourceSnapshot<Section, Contributor>()
        snapShot.appendSections([.main])
        snapShot.appendItems(contributors)
        DispatchQueue.main.async {
            self.dataSource.apply(snapShot, animatingDifferences: true)
        }
    }
    
    func updateData(commits: [Commit]) {
        
        var snapShot = NSDiffableDataSourceSnapshot<TableSection, Commit>()
        snapShot.appendSections([.main])
        snapShot.appendItems(commits)
        DispatchQueue.main.async {
            self.tableDataSource.apply(snapShot, animatingDifferences: true)
        }
    }
    
    
//MARK: - UIs
    func configureHeaderView() {
        view.addSubview(headerView)
        
        let repoDetailHeaderVC = RepoDetailHeaderVC(repo: repo)
        self.addChild(repoDetailHeaderVC)
        headerView.addSubview(repoDetailHeaderVC.view)
        repoDetailHeaderVC.view.frame = headerView.bounds
        repoDetailHeaderVC.didMove(toParent: self)
    }
    
    func layoutUIs() {
        
        headerView.translatesAutoresizingMaskIntoConstraints              = false
        contributorCollection.translatesAutoresizingMaskIntoConstraints   = false
        contributorLabel.translatesAutoresizingMaskIntoConstraints        = false
        commitTable.translatesAutoresizingMaskIntoConstraints             = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 150),
            
            contributorLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            contributorLabel.heightAnchor.constraint(equalToConstant: 17),
            contributorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            contributorCollection.topAnchor.constraint(equalTo: contributorLabel.bottomAnchor),
            contributorCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contributorCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contributorCollection.heightAnchor.constraint(equalToConstant: 150),
            
            commitTable.topAnchor.constraint(equalTo: contributorCollection.bottomAnchor, constant: 15),
            commitTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            commitTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            commitTable.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
//MARK: - extension
extension RepoDetailVC: UICollectionViewDelegate, UITableViewDelegate {
    
//MARK: - CollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let contributor = contributors[indexPath.item]
        let destinationVC = RepoListVC(username: contributor.login)

        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
//MARK: - TableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commits.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
