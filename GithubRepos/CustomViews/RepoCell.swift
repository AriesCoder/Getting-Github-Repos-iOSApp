//
//  RepoCell.swift
//  GithubRepos
//
//  Created by Aries Lam on 2/7/23.
//

import Foundation
import UIKit

class RepoCell: UITableViewCell {
    
    static let reuseID  = ReuseId.repoCell
    var repoImg         = UIImageView()
    let repoNameLabel   = GRTitleLabel(textAlighment: .left, fontSize: 20)
    let languageLabel   = GRSecondaryTitleLabel(fontSize: 15)
    let visibilityLabel = GRSecondaryTitleLabel(fontSize: 15)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(repo: Repo) {
        repoNameLabel.text      = repo.name
        languageLabel.text      = repo.language ?? "No language added."
        visibilityLabel.text    = repo.visibility
        repoImg.image           = UIHelper.configureLanguageLogo(with: repo.language ?? "No language added", to: repoImg)
    }
    func configure(){
        
        addSubview(repoImg)
        addSubview(repoNameLabel)
        addSubview(languageLabel)
        addSubview(visibilityLabel)
        
        repoImg.translatesAutoresizingMaskIntoConstraints = false
        languageLabel.textColor = .tintColor
        visibilityLabel.textColor = .systemGreen
  
        accessoryType               = .disclosureIndicator
        let padding: CGFloat        = 10
        let textImgPadding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            repoImg.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            repoImg.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            repoImg.heightAnchor.constraint(equalToConstant: 40),
            repoImg.widthAnchor.constraint(equalToConstant: 40),
            
            repoNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            repoNameLabel.leadingAnchor.constraint(equalTo: repoImg.trailingAnchor, constant: padding),
            repoNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -textImgPadding),
            repoNameLabel.heightAnchor.constraint(equalToConstant: 25),
            
            languageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            languageLabel.leadingAnchor.constraint(equalTo: repoImg.trailingAnchor, constant: textImgPadding),
            languageLabel.widthAnchor.constraint(equalToConstant: 150),
            languageLabel.heightAnchor.constraint(equalToConstant: 20),
            
            visibilityLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            visibilityLabel.widthAnchor.constraint(equalToConstant: 50),
            visibilityLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            visibilityLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
        
    }
}
