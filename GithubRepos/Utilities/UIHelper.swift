//
//  UIHelper.swift
//  GithubRepos
//
//  Created by Aries Lam on 2/14/23.
//

import Foundation
import UIKit

enum UIHelper {
    
    static func createThreeColumnCollectionViewLayout(view: UIView) -> UICollectionViewFlowLayout {
        
        let with                    = view.bounds.width
        let padding: CGFloat        = 12
        let cellSpacing: CGFloat    = 10
        let totalCellWidth          = with - (padding * 2) - (cellSpacing * 2)
        let cellWidth               = totalCellWidth / 3
        
        let flowLayout              = UICollectionViewFlowLayout()
        flowLayout.scrollDirection  = .horizontal
        flowLayout.sectionInset     = UIEdgeInsets(top: cellSpacing, left: padding, bottom: cellSpacing, right: padding)
        flowLayout.itemSize         = CGSize(width: cellWidth, height: cellWidth + 10)
        
        return flowLayout
        
    }
    
    static func configureLanguageLogo(with language: String, to repoImg: UIImageView) -> UIImage{

        switch language {
            case "Swift":
                repoImg.image   = languageLogo.swiftLogo
            case "Java":
                repoImg.image   = languageLogo.javaLogo
            case "JavaScript":
                repoImg.image   = languageLogo.javaScriptLogo
            case "Python":
                repoImg.image   = languageLogo.pythonLogo
            case "HTML":
                repoImg.image   = languageLogo.htmlLogo
            case "CSS":
                repoImg.image   = languageLogo.cssLogo
            case "C++":
                repoImg.image   = languageLogo.cPlusLogo
            case "Scala":
                repoImg.image   = languageLogo.scalaLogo
            case "Angular":
                repoImg.image   = languageLogo.angularLogo
            case "C":
                repoImg.image   = languageLogo.cLogo
            case "Ruby":
                repoImg.image   = languageLogo.rubyLogo
            case "Objective-C":
                repoImg.image   = languageLogo.objectiveCLogo
            case "No language added":
                repoImg.image   = languageLogo.noLanguage
            default:
                repoImg.image   = Icons.repoImg
        }
        return repoImg.image!
    }

}
