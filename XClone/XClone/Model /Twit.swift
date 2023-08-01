//
//  Twit.swift
//  XClone
//
//  Created by yun on 2023/08/01.
//

import Foundation

struct Twit: Codable {
    var nickName: String
    var mentionId: String
    var profileImage: String?
    var content: String
    var contentImage: String?
    
    private enum CodingKeys: String, CodingKey {
        case nickName = "nick_name"
        case mentionId = "mention_id"
        case profileImage = "profile_image"
        case content
        case contentImage = "content_image"
    }
}
