//
//  Community.swift
//  XClone
//
//  Created by yun on 2023/08/07.
//

import Foundation

struct Community: Decodable, Hashable {
    var communityTitle: String
    var communityImage: String
    var communityMemberCount: Int
    
    private enum Codingkeys: String, CodingKey {
        case communityTitle = "community_title"
        case communityImage = "community_image"
        case communityMemberCount = "community_member_count"
    }
}
