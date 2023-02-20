//
//  RepoListVC.swift
//  GithubRepos
//
//  Created by Aries Lam on 1/24/23.
//

import UIKit

class RepoListVC: UIViewController {
    
    enum Section {
        case main
    }
    
    var dataSource: UITableViewDiffableDataSource<Section, Repo>!
    
    var username            : String!
    let reposTable          = UITableView()
    let headerView          = UIView()
    var repos               = [Repo]()
    var originalRepos       = [Repo]()
    let searchView          = UIView()
    let sortMenuVC          = SortMenuVC()

    let networkManager  = NetworkManager()

    init(username: String!) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor    = .systemBackground
        layoutUI()
        getUserInfo()
        configureTableView()
        getRepo()
        configureNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData(repos: originalRepos)
        repos = originalRepos
    }
    
//MARK: - set up Navigation Bar
    func configureNavBar() {
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(sortBtnTapped))
    }
    
    @objc func sortBtnTapped(){
        
        guard !repos.isEmpty else {return}
        sortMenuVC.configureTransparentView(superView: view.self)
    }
    
//MARK: - fetching data from API
    func getUserInfo(){
        
        Task {
            do {
                let userInfo = try await networkManager.getUserInfo(username: username)
                configureUIs(user: userInfo)
            } catch {
                if let _ = error as? GRError {
                    presentGRAlert(title: "Something went wrong", message: "Please check username again!")
                }else{
                    presentDefaultError()
                }
            }
        }
    }
    
    
    func getRepo() {
        
        Task {
            do {
                let repoArr = try await networkManager.getRepoInfo(username: username)
                
                if repoArr.isEmpty {
                    emptyRepoView()
                }else{
                    originalRepos.append(contentsOf: repoArr)
                    repos.append(contentsOf: repoArr)
                    
                    DispatchQueue.main.async {
                        self.view.bringSubviewToFront(self.reposTable)
                        self.updateData(repos: self.repos)
                    }
                    
                  //pass data of repo array to SortMenuVC
                    sortMenuVC.updateSortMenuData(with: originalRepos)
                }
            } catch {
                if let _ = error as? GRError {
                    presentGRAlert(title: "Something went wrong", message: "Please check username again!")
                } else {
                    presentDefaultError()
                }
            }
        }
    }
    
    func emptyRepoView() {
        let msg = "\(username!) has no public repository yet."
        let logo = Images.emptyStateLogo
        let emptyRepoView = GREmptyStateView(message: msg, img: logo!)
        emptyRepoView.frame = view.bounds
        view.addSubview(emptyRepoView)
    }
    
//MARK: - DiffableDataSource
    func configureDataSource(){
        dataSource = UITableViewDiffableDataSource<Section, Repo>(tableView: reposTable, cellProvider: { tableView, indexPath, repo in
        
            let cell = tableView.dequeueReusableCell(withIdentifier: RepoCell.reuseID, for: indexPath) as! RepoCell
            cell.set(repo: repo)
            
            return cell
        })
    }

    func updateData(repos: [Repo]) {
        var snapShot        = NSDiffableDataSourceSnapshot<Section, Repo>()
        snapShot.appendSections([.main])
        snapShot.appendItems(repos)
        DispatchQueue.main.async {
            self.dataSource.apply(snapShot, animatingDifferences: true)
        }
    }
    
//MARK: - UIs
    func configureUIs(user: User){
        
        self.add(GRUserInfoHeaderVC(user: user), containerView: self.headerView)
    }
    
    func configureTableView() {
        
        reposTable.frame            = view.bounds
        reposTable.rowHeight        = 60
        reposTable.delegate         = self
        sortMenuVC.delegate         = self
        configureDataSource()
        reposTable.tableFooterView  = UIView(frame: .zero)

        reposTable.register(RepoCell.self, forCellReuseIdentifier: RepoCell.reuseID)
    }
    
   
    func layoutUI(){
        
        view.addSubview(headerView)
        view.addSubview(reposTable)
        
        let padding:    CGFloat = 20

        headerView.translatesAutoresizingMaskIntoConstraints = false
        reposTable.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 220),

            reposTable.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            reposTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            reposTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            reposTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding)
        ])
    }
}

//MARK: - extension Delegate
extension RepoListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let repo = repos[indexPath.row]
        let destVC = RepoDetailVC(repo: repo)
        navigationController?.pushViewController(destVC, animated: true)
    }
}

//MARK: - extension SortMenuDelegate
extension RepoListVC: SortMenuDelegate {
    
    func didSelectLanguage(with language: String) {
        
        //sort the reposTable with the selected language
        if language == "All" {
            updateData(repos: originalRepos)
            repos = originalRepos
        }
        else if language == "No language added" {
            repos = originalRepos.filter({ repo in
                repo.language == nil
            })
            updateData(repos: repos)

        }
        else {
            repos = originalRepos.filter({ repo in
                repo.language == language
            })
            updateData(repos: repos)
        }
    }
}
        
    
