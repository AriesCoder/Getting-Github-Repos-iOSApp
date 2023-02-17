//
//  SearchVC.swift
//  GithubRepos
//
//  Created by Aries Lam on 1/19/23.
//

import UIKit

class SearchVC: UIViewController {
    
    let logoImgView     = UIImageView()
    let usernameTF      = GRTextField()
    let actionBtn       = GRButton(color: .systemCyan, title: "Get Repo(s)", systemImg: SFSymbols.repos)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLogoImgView()
        configureTextField()
        configureCallToActionBtn()
        createDissmissKeyboardTapGesture()
    }
    
//     to hide the navigation bar when back to the search screen
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        usernameTF.text = ""

        //hide the navigation bar
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc func pushRepoListVC(){
        
        guard !usernameTF.text!.isEmpty else {
            presentGRAlert(title: "Empty Username", message: "Please make sure to enter a username!")
            return
        }
        view.endEditing(true)
        
        let repoListVC = RepoListVC(username: usernameTF.text!)
        navigationController?.pushViewController(repoListVC, animated: true)
    }
    
    //dismiss keyboard when click outside of the TextField
    func createDissmissKeyboardTapGesture(){
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    func configureLogoImgView(){
        view.addSubview(logoImgView)
        logoImgView.translatesAutoresizingMaskIntoConstraints   = false
        logoImgView.image   = Icons.gitLogo
        
        NSLayoutConstraint.activate([
            logoImgView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            logoImgView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImgView.heightAnchor.constraint(equalToConstant: 150),
            logoImgView.widthAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    
    func configureTextField(){
        view.addSubview(usernameTF)
        usernameTF.delegate = self
        NSLayoutConstraint.activate([usernameTF.topAnchor.constraint(equalTo: logoImgView.bottomAnchor, constant: 48),
                                     usernameTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
                                     usernameTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
                                     usernameTF.heightAnchor.constraint(equalToConstant: 50),
                                     ])
    }
    
    
    func configureCallToActionBtn(){

        actionBtn.addTarget(self, action: #selector(pushRepoListVC), for: .touchUpInside)
        view.addSubview(actionBtn)
        NSLayoutConstraint.activate([actionBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
                                     actionBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
                                     actionBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
                                     actionBtn.heightAnchor.constraint(equalToConstant: 50)])
    }
    

}

extension SearchVC: UITextFieldDelegate {
    //active "go" button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushRepoListVC()
        return true
    }
}
