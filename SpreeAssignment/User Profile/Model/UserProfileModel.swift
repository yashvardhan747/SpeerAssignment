//
//  UserProfileModel.swift
//  SpreeAssignment
//
//  Created by Astrotalk on 03/01/24.
//

import Foundation

struct UserProfileModel: Codable {
    let userName: String
    let name: String?
    let profileImageUrlString: String?
    let followersCount: Int?
    let followingCount: Int?
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case userName = "login"
        case name = "name"
        case profileImageUrlString = "avatar_url"
        case followersCount = "followers"
        case followingCount = "following"
        case description = "bio"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.userName = try container.decode(String.self, forKey: .userName)
        self.name = try? container.decode(String.self, forKey: .name)
        self.profileImageUrlString = try? container.decodeIfPresent(String.self, forKey: .profileImageUrlString)
        self.followersCount = try? container.decodeIfPresent(Int.self, forKey: .followersCount)
        self.followingCount = try? container.decodeIfPresent(Int.self, forKey: .followingCount)
        self.description = try? container.decodeIfPresent(String.self, forKey: .description)
    }
}
