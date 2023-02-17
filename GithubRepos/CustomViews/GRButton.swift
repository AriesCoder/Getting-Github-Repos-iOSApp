//
//  GRButton.swift
//  GithubRepos
//
//  Created by Aries Lam on 1/24/23.
//

import Foundation
import UIKit

class GRButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //convenience function doesnt need to call configure() again when it is already called in override init
    convenience init(color: UIColor, title: String, systemImg: String){
        self.init(frame: .zero)
        set(color: color, title: title, systemImg: systemImg)

    }

    private func configure(){
        //dont need to set color for the title of button because using tinted, just need color of button
        configuration = .tinted()
        
        configuration?.cornerStyle = .capsule
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    //this function is used for setting button later if no initial when created
    func set(color: UIColor, title: String, systemImg: String){
        configuration?.baseBackgroundColor = color   //for color of button
        configuration?.baseForegroundColor = color   //for color of the text
        configuration?.title = title
        
        //add img for buttons
        configuration?.image = UIImage(systemName: systemImg)
        configuration?.imagePadding = 6
        configuration?.imagePlacement = .leading
    }


}
