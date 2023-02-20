//
//  GREmptyStateView.swift
//  GithubRepos
//
//  Created by Aries Lam on 2/8/23.
//

import Foundation
import UIKit

class GREmptyStateView: UIView {
    
    let msgLabel    = GRTitleLabel(textAlighment: .center, fontSize: 30)
    let logoImgView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(message: String, img: UIImage){
        super.init(frame: .zero)
        msgLabel.text       = message
        logoImgView.image   = img
        configure()
    }
    
    func configure(){
        
        configureLogoImgView()
        configureMsgLabel()
    }
    
    func configureMsgLabel(){
        
        addSubview(msgLabel)
        
        msgLabel.numberOfLines  = 2
        msgLabel.textColor      = .secondaryLabel.withAlphaComponent(0.5)
        
        NSLayoutConstraint.activate([
            msgLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            msgLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            msgLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            msgLabel.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    func configureLogoImgView(){
        
        addSubview(logoImgView)
        
        logoImgView.alpha   = 0.2
        logoImgView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImgView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
            logoImgView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7),
            logoImgView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            logoImgView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}

