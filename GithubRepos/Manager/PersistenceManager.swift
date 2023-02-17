//
//  PersistenceManager.swift
//  GithubRepos
//
//  Created by Aries Lam on 2/16/23.
//

import Foundation

enum PersistenceActType{      //handle the action add or remove
    case add, remove
}

enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    enum Keys{
       static let bookmarks = "bookmarks"
    }
    
    
    static func updateData(with repo: Repo, actionType: PersistenceActType, completed: @escaping(GRError?) -> Void) {
        
        retrieveBookmarks { result in
            
            switch result {
            case .success(var repos):
                switch actionType{
                case .add:
                    guard !repos.contains(repo) else {
                        completed(.alreadyInBookmark)
                        return
                    }
                    repos.append(repo)
                case .remove:
                    repos.removeAll{$0.name == repo.name}
                }
                
                completed(saveToDefaults(repos: repos))
                
            case .failure(let error):
                completed(error)
            }
            
        }
    }
    
    
    static func retrieveBookmarks(completed: @escaping (Result<[Repo], GRError>) -> Void) {
        
        guard let repoData = defaults.object(forKey: Keys.bookmarks) as? Data else {
            completed(.success([]))
            return
        }
        
        do{
            let decoder = JSONDecoder()
            let repos = try decoder.decode([Repo].self, from: repoData)
            completed(.success(repos))
        }catch{
            completed(.failure(.unableToBookmark))
        }
    }
    
    static func saveToDefaults(repos: [Repo]) -> GRError? {
        
        do {
            let encoder = JSONEncoder()
            let encodeRepo = try encoder.encode(repos)
            defaults.set(encodeRepo, forKey: Keys.bookmarks)
            return nil
        }catch{
            return .unableToBookmark
        }
    }
}
