//
//  GRTextField.swift
//  GithubRepos
//
//  Created by Aries Lam on 1/24/23.
//

import Foundation
import UIKit

class GRTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius  = 10
        layer.borderWidth   = 2
        layer.borderColor   = UIColor.systemCyan.cgColor
        
        textColor           = .label
        tintColor           = .label
        textAlignment       = .center
        font                = UIFont.preferredFont(forTextStyle: .title2)
        adjustsFontSizeToFitWidth = true
        minimumFontSize     = 12
        
        backgroundColor     = .tertiarySystemBackground
        autocorrectionType  = .no
        returnKeyType       = .go
        clearButtonMode     = .whileEditing
        
        placeholder         = "Enter a username"
    }
}
