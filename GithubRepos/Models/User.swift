//
//  User.swift
//  GithubRepos
//
//  Created by Aries Lam on 1/25/23.
//

import Foundation

struct User: Codable {
    
    let login           : String
    let avatarUrl       : String
    let name            : String?
    let bio             : String?
    let htmlUrl         : String
    let reposUrl        : String?
    let email           : String?
    let twitterUsername : String?
    let location        : String?
}
