//
//  UserSearchStrategy.swift
//  UserFinder
//
//  Created by Amit Samant on 25/10/20.
//

import Foundation

protocol UserSearchStrategy {
    func searchUser(withName name: String, completion: @escaping (Result<[User], Error>) -> Void)
}
