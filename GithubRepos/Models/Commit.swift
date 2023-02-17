//
//  Commit.swift
//  GithubRepos
//
//  Created by Aries Lam on 2/12/23.
//

import Foundation

//https://api.github.com/repos/Jackwanacode/AirBnB_clone/commits
struct Commit: Codable, Hashable {
    
    var commit      : CommitDetail
    let htmlUrl     : String
    
}

struct CommitDetail    : Codable, Hashable {
    let message     : String
    let committer   : Committer
}

struct Committer    : Codable, Hashable {
    let name        : String
    let date        : Date
}
