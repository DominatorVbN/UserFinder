//
//  GitUserStrategy.swift
//  UserFinder
//
//  Created by Amit Samant on 25/10/20.
//

import Foundation
import Combine

class GitUserStrategy: UserSearchStrategy {
    
    var cancellable: AnyCancellable?
    
    func searchUser(withName name: String, completion: @escaping (Result<[User], Error>) -> Void) {
        
        guard var component = URLComponents(string: "https://api.github.com/search/users") else {
            completion(.failure(StrategyError.invalidURL))
            return
        }
        
        component.queryItems = [
            URLQueryItem(name: "q", value: name)
        ]
        
        guard let url = component.url else {
            completion(.failure(StrategyError.invalidURL))
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Response.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .map(\.items)
            .sink { com in
                switch com {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    break
                }
            } receiveValue: { (users) in
                completion(.success(users))
            }
    }
}
