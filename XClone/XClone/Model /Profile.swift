//
//  Profile.swift
//  XClone
//
//  Created by yun on 2023/08/01.
//

import Foundation

struct Profile: Decodable, Hashable {
    var name: String
    var mentionId: String
    var smallImage: String?
    var bigImage: String?
    var introduction: String
    var region: String
    var webSite: String
    var birthDate: String
    
    private enum CodingKeys: String, CodingKey {
        case name
        case mentionId = "mention_id"
        case smallImage = "small_image"
        case bigImage = "big_image"
        case introduction
        case region
        case webSite = "web_site"
        case birthDate = "birth_date"
    }
}
