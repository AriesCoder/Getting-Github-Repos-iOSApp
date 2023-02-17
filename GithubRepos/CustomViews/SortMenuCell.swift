//
//  SortMenuCell.swift
//  GithubRepos
//
//  Created by Aries Lam on 2/10/23.
//

import Foundation
import UIKit

class SortMenuCell: UITableViewCell {
    
    static let reuseID  = ReuseId.sortMenuCell
    let languageLogo    = UIImageView()
    var languageLabel   = GRTitleLabel(textAlighment: .center, fontSize: 17)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(label: String) {
        languageLabel.text = label
        languageLogo.image  = UIHelper.configureLanguageLogo(with: label, to: languageLogo)
    }
    
    func configureCell() {
        addSubview(languageLogo)
        addSubview(languageLabel)
        languageLogo.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 30
        
        NSLayoutConstraint.activate([
        
            languageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            languageLabel.heightAnchor.constraint(equalToConstant: padding),
            languageLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            
            languageLogo.trailingAnchor.constraint(equalTo: languageLabel.leadingAnchor, constant: -15),
            languageLogo.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            languageLogo.heightAnchor.constraint(equalToConstant: padding),
            languageLogo.widthAnchor.constraint(equalToConstant: padding),
        ])
    }
}
