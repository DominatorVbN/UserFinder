//
//  Response.swift
//  UserFinder
//
//  Created by Amit Samant on 25/10/20.
//

import Foundation

struct Response: Decodable {
    let items: [User]
}
