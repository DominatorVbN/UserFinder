//
//  User.swift
//  UserFinder
//
//  Created by Amit Samant on 25/10/20.
//

import Foundation

struct User: Decodable, Identifiable {
    let image: URL
    let name: String
    var id: String {
        name
    }
    
    enum CodingKeys: String, CodingKey {
        case owner
        case profileImage = "profile_image"
        case displayName = "display_name"
        case avatarImage = "avatar_url"
        case name = "login"
    }
    
    enum UserError: Error {
        case invalidImageURL
        case imageNotFound
        case nameNotFound
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nestedContainer = try? container.nestedContainer(keyedBy: CodingKeys.self, forKey: .owner)

        let stackImage = try nestedContainer?.decodeIfPresent(String.self, forKey: .profileImage)
        let gitImage = try container.decodeIfPresent(String.self, forKey: .avatarImage)

        guard let imageStr = stackImage ?? gitImage else {
            throw UserError.imageNotFound
        }

        guard let imageURL = URL(string: imageStr) else {
            throw UserError.invalidImageURL
        }

        self.image = imageURL
        let stackName = try nestedContainer?.decodeIfPresent(String.self, forKey: .displayName)
        let gitName = try container.decodeIfPresent(String.self, forKey: .name)
        
        self.name = stackName ?? gitName ?? "N/A"
    }
}
