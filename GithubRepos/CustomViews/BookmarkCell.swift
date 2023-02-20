//
//  BookmarkCell.swift
//  GithubRepos
//
//  Created by Aries Lam on 2/16/23.
//

import UIKit

class BookmarkCell: UITableViewCell {
    
    static let reuseID  = ReuseId.bookmarkCell
    let repoNameLabel   = GRTitleLabel(textAlighment: .left, fontSize: 17)
    let owner           = GRSecondaryTitleLabel(fontSize: 17)
    var ownerAvtUrl     : String!
    let ownerImg        = GRAvtImgView(frame: .zero)
    let languageLabel   = GRSecondaryTitleLabel(fontSize: 15)
    let languageIcon    = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(repo: Repo){
        ownerAvtUrl = repo.owner.avatarUrl
        repoNameLabel.text  = repo.name
        owner.text          = repo.owner.login
        ownerImg.downloadImg(fromURL: ownerAvtUrl)
        languageLabel.text  = repo.language ?? "No language added"
        languageIcon.image  = UIHelper.configureLanguageLogo(with: repo.language ?? "No language added", to: languageIcon)
        
    }
    
    func configure() {
        
        addSubview(repoNameLabel)
        addSubview(owner)
        addSubview(ownerImg)
        addSubview(languageIcon)
        addSubview(languageLabel)
        
        languageIcon.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 20
        let textImgpadding: CGFloat = 5
        
        NSLayoutConstraint.activate([
            
            languageIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: textImgpadding),
            languageIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            languageIcon.widthAnchor.constraint(equalToConstant: 15),
            languageIcon.heightAnchor.constraint(equalToConstant: 15),
            
            languageLabel.leadingAnchor.constraint(equalTo: languageIcon.trailingAnchor, constant: textImgpadding),
            languageLabel.topAnchor.constraint(equalTo: languageIcon.topAnchor),
            languageLabel.heightAnchor.constraint(equalToConstant: 17),
            
            repoNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -textImgpadding),
            repoNameLabel.leadingAnchor.constraint(equalTo: languageIcon.leadingAnchor),
            repoNameLabel.heightAnchor.constraint(equalToConstant: 20),
            repoNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            owner.topAnchor.constraint(equalTo: languageIcon.topAnchor),
            owner.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            owner.heightAnchor.constraint(equalToConstant: 20),
            
            ownerImg.trailingAnchor.constraint(equalTo: owner.leadingAnchor, constant: -textImgpadding),
            ownerImg.heightAnchor.constraint(equalToConstant: 17),
            ownerImg.widthAnchor.constraint(equalTo: ownerImg.heightAnchor),
            ownerImg.topAnchor.constraint(equalTo: owner.topAnchor)
        ])
    }
}
