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
    var profileImage: Data?
    var content: String
    var contentImage: Data?
}
