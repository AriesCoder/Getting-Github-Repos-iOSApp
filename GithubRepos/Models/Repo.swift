//
//  Repo.swift
//  GithubRepos
//
//  Created by Aries Lam on 2/7/23.
//

import Foundation
import UIKit

struct Repo: Codable, Hashable {
    
    let name                : String
    var language            : String?
    let visibility          : String
    let htmlUrl             : String
    let contributorsUrl     : String
    let createdAt           : Date
    let updatedAt           : Date
    let commitsUrl          : String
    let owner               : Owner
}

struct Owner: Codable, Hashable {
    let login       : String
    let avatarUrl   : String
}
