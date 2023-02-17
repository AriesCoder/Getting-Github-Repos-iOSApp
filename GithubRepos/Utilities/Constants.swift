//
//  Constants.swift
//  GithubRepos
//
//  Created by Aries Lam on 1/24/23.
//

import Foundation
import UIKit

enum SFSymbols {
    
    static let repos        = "doc.fill"
    static let location     = "mappin.and.ellipse"
}

enum Images {
    
    static let placeHolder      = UIImage(named: "noAvtImg")
    static let fullnameImg      = UIImage(systemName: "person.crop.square.fill")
    static let gitURLImg        = UIImage(named: "GitHubLogo")
    static let emailImg         = UIImage(systemName: "envelope.fill")
    static let twittetImg       = UIImage(named: "twitterLogo")
    static let locationImg      = UIImage(systemName: "mappin.and.ellipse")
    static let emptyStateLogo   = UIImage(named: "NoRepoIcon")
    static let sortBtnImg       = UIImage(named: "sortButton")
}

enum languageLogo {
    static let swiftLogo        = UIImage(named: "Swift")
    static let javaLogo         = UIImage(named: "Java")
    static let scalaLogo        = UIImage(named: "Scala")
    static let javaScriptLogo   = UIImage(named: "JavaScript")
    static let cPlusLogo        = UIImage(named: "C++")
    static let htmlLogo         = UIImage(named: "HTML")
    static let cssLogo          = UIImage(named: "CSS")
    static let pythonLogo       = UIImage(named: "Python")
    static let reactLogo        = UIImage(named: "React")
    static let cLogo            = UIImage(named: "C")
    static let angularLogo      = UIImage(named: "Angular")
    static let rubyLogo         = UIImage(named: "Ruby")
    static let objectiveCLogo   = UIImage(named: "ObjectiveC")
    static let noLanguage       = UIImage(systemName: "questionmark")
}

enum ReuseId {
    static let repoCell         = "RepoCell"
    static let sortMenuCell     = "MenuCell"
    static let contributorCell  = "ContributorCell"
    static let commitCell       = "CommitCell"
    static let bookmarkCell     = "BookmarkCell"
}

enum Icons {
    static let externalURL      = UIImage(named: "externalURLIcon")
    static let createdDate      = UIImage(systemName: "square.and.pencil")
    static let updateDate       = UIImage(named: "updateIcon")
    static let gitLogo          = UIImage(named: "gitIcon")
    static let repoImg          = UIImage(named: "repoIcon")
    static let bookmark         = UIImage(systemName: "book")
}
