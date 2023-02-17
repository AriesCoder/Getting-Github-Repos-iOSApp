//
//  GRSecondaryTitleLabel.swift
//  GithubRepos
//
//  Created by Aries Lam on 1/25/23.
//

import Foundation
import UIKit

class GRSecondaryTitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(fontSize: CGFloat){
        self.init(frame: .zero)
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
    }
    
    private func configure(){
        textColor = .secondaryLabel
        adjustsFontSizeToFitWidth = true   //shrink the text if it is too long
        minimumScaleFactor = 0.9           //minimum shrink is 90%
        lineBreakMode = .byTruncatingTail   // "..." if the text is too long
        translatesAutoresizingMaskIntoConstraints = false
        
    }
    
}
