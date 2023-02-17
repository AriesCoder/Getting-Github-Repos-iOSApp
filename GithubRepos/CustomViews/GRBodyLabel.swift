//
//  GRBodyLabel.swift
//  GithubRepos
//
//  Created by Aries Lam on 1/25/23.
//

import Foundation
import UIKit

class GRBodyLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(textAlignment: NSTextAlignment){
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        configure()
    }
    
    private func configure(){
        textColor                                   = .secondaryLabel
        font                                        = .preferredFont(forTextStyle: .body)
        adjustsFontForContentSizeCategory           = true //can adjust font with dynamic type
        adjustsFontSizeToFitWidth                   = true
        minimumScaleFactor                          = 0.75
        lineBreakMode                               = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints   = false
    }
}
