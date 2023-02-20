//
//  RepoDetailVC.swift
//  GithubRepos
//
//  Created by Aries Lam on 2/13/23.
//

import UIKit
import SafariServices

class RepoDetailVC: UIViewController {
    
    enum Section {
        case main
    }
    
    enum TableSection{
        case main
    }
    
    let headerView              = UIView()
    let emptyCollectionView     = EmptyCollectionView(frame: .zero)
    var contributorCollection   : UICollectionView!
    let commitTable             = UITableView()
    
    var dataSource              : UICollectionViewDiffableDataSource<Section, Contributor>!
    var tableDataSource         : UITableViewDiffableDataSource<TableSection, Commit>!
    
    let contributorIcon         = UIImageView(image: UIImage(systemName: "person.3"))
    var contributors            = [Contributor]()
    var commits                 = [Commit]()
    let commitLabel             = GRSecondaryTitleLabel(fontSize: 17)
    let commitIcon              = UIImageView(image: UIImage(systemName: "pencil.line"))
    var repo                    : Repo!
    var contributor             : Contributor!
    let contributorLabel        = GRSecondaryTitleLabel(fontSize: 17)
    
    init(repo: Repo) {
        super.init(nibName: nil, bundle: nil)
        self.repo = repo
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        getContributor(of: repo)
        getCommits(of: repo)
        configureHeaderView()
        configureCollectionView()
        configureTableView()
        layoutUIs()
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//            super.viewWillDisappear(animated)
//                print("REpodetail view will disappear")
//                navigationController?.popViewController(animated: true)
//            
//        }

//MARK: - Configure views
    func configureCollectionView() {
    
        contributorCollection = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnCollectionViewLayout(view: view))
        view.addSubview(contributorCollection)
        view.addSubview(contributorLabel)
        contributorCollection.delegate          = self
        contributorCollection.layer.cornerRadius   = 20
        contributorCollection.layer.masksToBounds  = true
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
                guard !contributors.isEmpty else{
                    emptyCollectionView.isHidden    = false
                    contributorCollection.isHidden  = true
                    emptyCollectionView.set(message: "There is no contributor for this repo.")
                    return
                }
                emptyCollectionView.isHidden        = true
                contributorCollection.isHidden      = false
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
        headerView.layer.cornerRadius   = 20
        headerView.layer.masksToBounds  = true
        
        let repoDetailHeaderVC = RepoDetailHeaderVC(repo: repo)
        self.addChild(repoDetailHeaderVC)
        headerView.addSubview(repoDetailHeaderVC.view)
        repoDetailHeaderVC.view.frame = headerView.bounds
        repoDetailHeaderVC.didMove(toParent: self)
    }
    
    func configureViewController(){
        
        view.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bookmark.fill"), style: .plain, target: self, action: #selector(addBtnTapped))
        navigationController?.navigationBar.barTintColor   = .systemBackground
        
        view.addSubview(contributorIcon)
        contributorIcon.tintColor   = .black
        contributorLabel.text       = "Contributor(s)"
        
        view.addSubview(commitIcon)
        view.addSubview(commitLabel)
        commitIcon.tintColor        = .black
        commitLabel.text            = "Commit(s)"
        
        view.addSubview(emptyCollectionView)
        emptyCollectionView.backgroundColor = .systemBackground
        emptyCollectionView.layer.cornerRadius = 20
        emptyCollectionView.layer.masksToBounds = true
    }
    
    func layoutUIs() {
        
        headerView.translatesAutoresizingMaskIntoConstraints              = false
        contributorCollection.translatesAutoresizingMaskIntoConstraints   = false
        contributorLabel.translatesAutoresizingMaskIntoConstraints        = false
        commitTable.translatesAutoresizingMaskIntoConstraints             = false
        contributorIcon.translatesAutoresizingMaskIntoConstraints         = false
        commitIcon.translatesAutoresizingMaskIntoConstraints              = false
        emptyCollectionView.translatesAutoresizingMaskIntoConstraints     = false
        
        let secondLabelHeight: CGFloat  = 17
        let padding: CGFloat            = 20
        let nextViewPadding: CGFloat    = 10
        let iconHeight: CGFloat         = 15
        let textIconPadding: CGFloat    = 5
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 140),
            
            contributorIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            contributorIcon.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: nextViewPadding),
            contributorIcon.heightAnchor.constraint(equalToConstant: iconHeight),
            contributorIcon.widthAnchor.constraint(equalToConstant: 20),
            
            contributorLabel.topAnchor.constraint(equalTo: contributorIcon.topAnchor),
            contributorLabel.heightAnchor.constraint(equalToConstant: secondLabelHeight),
            contributorLabel.leadingAnchor.constraint(equalTo: contributorIcon.trailingAnchor, constant: textIconPadding),
            
            contributorCollection.topAnchor.constraint(equalTo: contributorLabel.bottomAnchor, constant: 5),
            contributorCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contributorCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contributorCollection.heightAnchor.constraint(equalToConstant: 120),
            
            emptyCollectionView.topAnchor.constraint(equalTo: contributorLabel.bottomAnchor, constant: 5),
            emptyCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyCollectionView.heightAnchor.constraint(equalToConstant: 120),
            
            commitIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: padding),
            commitIcon.topAnchor.constraint(equalTo: contributorCollection.bottomAnchor, constant: nextViewPadding),
            commitIcon.heightAnchor.constraint(equalToConstant: iconHeight),
            commitIcon.widthAnchor.constraint(equalTo: commitIcon.heightAnchor),
            
            commitLabel.leadingAnchor.constraint(equalTo: commitIcon.trailingAnchor, constant: textIconPadding),
            commitLabel.topAnchor.constraint(equalTo: commitIcon.topAnchor),
            commitLabel.heightAnchor.constraint(equalToConstant: secondLabelHeight),
            
            commitTable.topAnchor.constraint(equalTo: commitIcon.bottomAnchor, constant: 5),
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
        
        let commit = commits[indexPath.row]
        guard let url = URL(string: commit.htmlUrl) else{
            presentGRAlert(title: "Invalid URL", message: "The url attached to this commit is invalid")
            return}
        
        presentSafariVC(with: url)
    }

}
