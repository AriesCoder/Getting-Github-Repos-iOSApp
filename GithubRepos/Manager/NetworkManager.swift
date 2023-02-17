//
//  NetworkManager.swift
//  GithubRepos
//
//  Created by Aries Lam on 1/25/23.
//

import Foundation
import UIKit

class NetworkManager {
    
    private let baseURL     = "https://api.github.com/"
    let cache               = NSCache<NSString, UIImage>()
    
    func downloadImg(with urlString: String) async -> UIImage?{
        
        let cacheKey = NSString(string: urlString)
        
        if let img = cache.object(forKey: cacheKey){
            return img
        }
        
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let img = UIImage(data: data) else { return nil }
            cache.setObject(img, forKey: cacheKey)
            return img
        }
        catch {
            return nil
        }
    }
    
    func getUserInfo(username: String) async throws -> User{
        
        let endpoint = baseURL + "users/\(username)"
        
        guard let url = URL(string: endpoint) else { throw GRError.invalidUsername }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200
        else { throw GRError.invalidResponse   }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let user = try decoder.decode(User.self, from: data)
            return user
        } catch {
            throw GRError.invalidData
        }
    }
    
    func getRepoInfo(username: String) async throws -> [Repo] {
        let endpoint = baseURL + "users/\(username)/repos"
        
        guard let url = URL(string: endpoint) else {
            throw GRError.invalidUsername
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GRError.invalidResponse
        }
        
        do{
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .iso8601 //convert String to Date
            let repos = try decoder.decode([Repo].self, from: data)

            return repos
        } catch {
            throw GRError.invalidData
        }
        
    }
    
    func getContributor(with url: String) async throws -> [Contributor] {
        
        guard let url = URL(string: url) else {
            throw GRError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GRError.invalidResponse
        }
        
        do{
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let contributors = try decoder.decode([Contributor].self, from: data)

            return contributors
        } catch {
            throw GRError.invalidData
        }
        
    }
    
    func getCommits(with commitsUrl: String) async throws -> [Commit] {
        
        let commitsURLWithoutSha = commitsUrl.replacingOccurrences(of: "{/sha}", with: "")
        
        guard let url = URL(string: commitsURLWithoutSha) else {
            throw GRError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GRError.invalidResponse
        }
        
        do{
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .iso8601
            let commits = try decoder.decode([Commit].self, from: data)

            return commits
        } catch {
            
            print(error)
            throw GRError.invalidData
        }
        
    }
}
