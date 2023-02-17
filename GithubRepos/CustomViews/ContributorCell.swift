//
//  ContributorCell.swift
//  GithubRepos
//
//  Created by Aries Lam on 2/14/23.
//

import UIKit

class ContributorCell: UICollectionViewCell {
    
    static let reuseID   = ReuseId.contributorCell
    let contributorImg   = GRAvtImgView(frame: .zero)
    var contributorName  = GRTitleLabel(textAlighment: .center, fontSize: 17)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(contributor: Contributor){
        
        contributorName.text = contributor.login
        contributorImg.downloadImg(fromURL: contributor.avatarUrl)
    }
    
    func configureCell(){
        
        contentView.addSubview(contributorImg)
        contentView.addSubview(contributorName)
        
        let padding: CGFloat    = 20
        
        NSLayoutConstraint.activate([
            contributorImg.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            contributorImg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            contributorImg.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            contributorImg.heightAnchor.constraint(equalTo: contributorImg.widthAnchor),
            
            contributorName.topAnchor.constraint(equalTo: contributorImg.bottomAnchor, constant: 10),
            contributorName.centerXAnchor.constraint(equalTo: contributorImg.centerXAnchor),
            contributorName.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            contributorName.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
