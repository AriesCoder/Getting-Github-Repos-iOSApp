//
//  GRErrors.swift
//  GithubRepos
//
//  Created by Aries Lam on 1/25/23.
//

import Foundation


enum GRError: String, Error{
    case invalidUsername    = "This username created an invalid request. Please try again"
    case unableToComplete   = "Unable to complete your request. Please check your connection "
    case invalidResponse    = "Invalid response from the server. Please try again!"
    case invalidData        = "The data received from the server was invalid. Please try again!"
    case unableToBookmark   = " There was an error bookmarking this repo."
    case alreadyInBookmark  = " You're already bookmarked this repo"
    case invalidURL         = "This contributor request is invalid. Please try again"
    case emptyRepoDetail    = " Sorry! This repository is empty"
}
