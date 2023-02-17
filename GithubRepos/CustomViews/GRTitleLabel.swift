//
//  GRTitleLabel.swift
//  GithubRepos
//
//  Created by Aries Lam on 1/24/23.
//

import Foundation
import UIKit

class GRTitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(textAlighment: NSTextAlignment, fontSize: CGFloat){
        
        self.init(frame: .zero)
        self.textAlignment  = textAlighment
        self.font           = UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }
    
    
    private func configure(){
        textColor = .label
        adjustsFontSizeToFitWidth = true   //shrink the text if it is too long
        minimumScaleFactor = 0.9           //minimum shrink is 90%
        lineBreakMode = .byTruncatingTail  // "..." if the text is too long
        translatesAutoresizingMaskIntoConstraints = false
    }
}
