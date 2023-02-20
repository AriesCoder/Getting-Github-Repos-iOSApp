//
//  EmptyCollectionView.swift
//  GithubRepos
//
//  Created by Aries Lam on 2/17/23.
//

import Foundation
import UIKit

class EmptyCollectionView: UIView {
    
    let message = GRTitleLabel(textAlighment: .center, fontSize: 20)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(message: String){
        self.message.text = message
    }
    
    func configure() {
        
        addSubview(message)
        message.numberOfLines   = 2
        message.textColor       = .secondaryLabel.withAlphaComponent(0.5)
        
        NSLayoutConstraint.activate([
            message.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            message.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            message.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            message.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30)
        ])
    }
}
