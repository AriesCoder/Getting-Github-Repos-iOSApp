//
//  CommitCell.swift
//  GithubRepos
//
//  Created by Aries Lam on 2/15/23.
//

import Foundation
import UIKit

class CommitCell: UITableViewCell {
    
    static let reuseID  = ReuseId.commitCell
    let commitMessage   = GRTitleLabel(textAlighment: .left, fontSize: 16)
    let committer       = GRSecondaryTitleLabel(fontSize: 15)
    let commitDateLabel      = GRSecondaryTitleLabel(fontSize: 12)
    var htmlURL         : String!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(repCommit: Commit){
        commitMessage.text      = repCommit.commit.message
        committer.text          = repCommit.commit.committer.name
            
        let commitDate          = repCommit.commit.committer.date
        commitDateLabel.text    = "\(commitDate.convertToMyFormat())"
        htmlURL                 = repCommit.htmlUrl
    }
    
    func configure(){
        
        addSubview(commitMessage)
        addSubview(committer)
        addSubview(commitDateLabel)
        
        commitDateLabel.textAlignment   = .right
        commitMessage.numberOfLines     = 3
        commitMessage.lineBreakMode     = .byWordWrapping
  
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            commitMessage.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            commitMessage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            commitMessage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            commitMessage.heightAnchor.constraint(equalToConstant: 70),
            
            committer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            committer.heightAnchor.constraint(equalToConstant: 13),
            committer.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            
            commitDateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            commitDateLabel.heightAnchor.constraint(equalToConstant: 13),
            commitDateLabel.leadingAnchor.constraint(equalTo: committer.trailingAnchor),
            commitDateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])
    }
}
