//
//  Date.swift
//  GithubRepos
//
//  Created by Aries Lam on 2/14/23.
//

import Foundation

extension Date {
    func convertToMyFormat() -> String{
        return formatted(.dateTime.day(.twoDigits).month(.wide).year())
    }
}
