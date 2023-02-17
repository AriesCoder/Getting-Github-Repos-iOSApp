//
//  RepoDetailHeaderVC.swift
//  GithubRepos
//
//  Created by Aries Lam on 2/13/23.
//

import UIKit
import SafariServices

class RepoDetailHeaderVC: UIViewController {
    
    let languageLabel           = GRSecondaryTitleLabel(fontSize: 20)
    let languageLogo            = UIImageView()
    let repoNameLabel           = GRTitleLabel(textAlighment: .left, fontSize: 30)
    let externalURLImg          = UIImageView()
    let externalURLLabel        = GRSecondaryTitleLabel(fontSize: 12)
    let createdLabel            = GRSecondaryTitleLabel(fontSize: 13)
    let createIcon              = UIImageView()
    let updateLabel             = GRSecondaryTitleLabel(fontSize: 13)
    let updateIcon              = UIImageView()
    
    var repo: Repo!
   
    init(repo: Repo){
        super.init(nibName: nil, bundle: nil)
        self.repo = repo
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        layoutUIs()
        configureUIElements()
    }
    
    func configureUIElements() {
        
        let repoLanguage = repo.language ?? "No language added"
        languageLogo.image = UIHelper.configureLanguageLogo(with: repoLanguage, to: languageLogo)
//        configureLanguageLogo(with: repoLanguage, to: languageLogo)
        languageLabel.text          = repoLanguage
        languageLabel.textColor     = .systemOrange
            
        repoNameLabel.text          = repo.name
            
        externalURLImg.image        = Icons.externalURL
        externalURLLabel.textColor  = .tintColor
        hyperlinkLabel(label: externalURLLabel, url: repo.htmlUrl, string: "Jump to source code")
        
        createIcon.image            = Icons.createdDate
        createIcon.tintColor        = .black
        createdLabel.text           = "Created At: \(repo.createdAt.convertToMyFormat())"
    
        updateIcon.image            = Icons.updateDate
        updateLabel.text            = "Updated At: \(repo.updatedAt.convertToMyFormat())"
    }
    
    func hyperlinkLabel(label: UILabel, url: String, string: String){
        label.attributedText =
        NSMutableAttributedString(string: string, attributes:[NSAttributedString.Key.link: URL(string: url)!])
        label.isUserInteractionEnabled = true
        
        let guestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        label.addGestureRecognizer(guestureRecognizer)
    }
    
    @objc func labelTapped(){
        let safariVC = SFSafariViewController(url: URL(string: repo.htmlUrl)!)
            safariVC.preferredControlTintColor = .systemGreen
            present(safariVC, animated: true)
     
    }
    
    func addViews() {
        
        view.addSubview(languageLabel)
        view.addSubview(languageLogo)
        
        view.addSubview(repoNameLabel)
        
        view.addSubview(externalURLImg)
        view.addSubview(externalURLLabel)
        
        view.addSubview(createdLabel)
        view.addSubview(createIcon)
        
        view.addSubview(updateLabel)
        view.addSubview(updateIcon)
    }
    
    func layoutUIs(){
        
        let textImgPadding: CGFloat = 10
        let padding: CGFloat = 20
        addViews()
        
        languageLogo.translatesAutoresizingMaskIntoConstraints = false
        externalURLImg.translatesAutoresizingMaskIntoConstraints = false
        createIcon.translatesAutoresizingMaskIntoConstraints = false
        updateIcon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            languageLogo.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            languageLogo.trailingAnchor.constraint(equalTo: languageLabel.leadingAnchor, constant: -textImgPadding),
            languageLogo.heightAnchor.constraint(equalToConstant: padding),
            languageLogo.widthAnchor.constraint(equalTo: languageLogo.heightAnchor),
            
//            languageLabel.leadingAnchor.constraint(equalTo: languageLogo.trailingAnchor, constant: textImgPadding),
            languageLabel.topAnchor.constraint(equalTo: languageLogo.topAnchor),
            languageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            languageLabel.heightAnchor.constraint(equalToConstant: padding),
            
            externalURLLabel.bottomAnchor.constraint(equalTo: repoNameLabel.topAnchor),
            externalURLLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            externalURLLabel.heightAnchor.constraint(equalToConstant: 15),
            externalURLLabel.topAnchor.constraint(equalTo: languageLogo.bottomAnchor, constant: 5),
            
            externalURLImg.centerYAnchor.constraint(equalTo: externalURLLabel.centerYAnchor),
            externalURLImg.trailingAnchor.constraint(equalTo: externalURLLabel.leadingAnchor, constant: -3),
            externalURLImg.widthAnchor.constraint(equalToConstant: 8),
            externalURLImg.heightAnchor.constraint(equalToConstant: 8),
            
            repoNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            repoNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            repoNameLabel.topAnchor.constraint(equalTo: externalURLLabel.bottomAnchor),
            repoNameLabel.heightAnchor.constraint(equalToConstant: 32),
            
            
            createIcon.topAnchor.constraint(equalTo: repoNameLabel.bottomAnchor, constant: textImgPadding),
            createIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            createIcon.heightAnchor.constraint(equalToConstant: 15),
            createIcon.widthAnchor.constraint(equalTo: createIcon.heightAnchor),
            
            createdLabel.leadingAnchor.constraint(equalTo: createIcon.trailingAnchor, constant: textImgPadding),
            createdLabel.centerYAnchor.constraint(equalTo: createIcon.centerYAnchor),
            createdLabel.heightAnchor.constraint(equalToConstant: padding),
            createdLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),

            updateIcon.topAnchor.constraint(equalTo: createIcon.bottomAnchor, constant: textImgPadding),
            updateIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            updateIcon.heightAnchor.constraint(equalToConstant: 15),
            updateIcon.widthAnchor.constraint(equalTo: updateIcon.heightAnchor),
            
            updateLabel.leadingAnchor.constraint(equalTo: updateIcon.trailingAnchor, constant: textImgPadding),
            updateLabel.centerYAnchor.constraint(equalTo: updateIcon.centerYAnchor),
            updateLabel.heightAnchor.constraint(equalToConstant: padding),
            updateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),


        ])
    }
}
