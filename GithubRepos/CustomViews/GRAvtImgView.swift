//
//  GRAvtImgView.swift
//  GithubRepos
//
//  Created by Aries Lam on 1/24/23.
//

import Foundation
import UIKit

class GRAvtImgView: UIImageView {
    
    let emptyImgPlaceholder = Images.placeHolder

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        layer.cornerRadius = 10
        clipsToBounds = true
        image = emptyImgPlaceholder
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func downloadImg(fromURL url: String){
        Task {
            image = await NetworkManager().downloadImg(with: url) ?? emptyImgPlaceholder
        }
    }
}
