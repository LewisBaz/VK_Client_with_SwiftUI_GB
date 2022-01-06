//
//  ImageModel.swift
//  VK_Client_SwiftUI
//
//  Created by Lewis on 06.12.2021.
//

import Foundation

// MARK: - ImageResponse
struct ImageResponse: Codable {
    let response: Response
}

// MARK: - Response
struct Response: Codable {
    let count: Int
    let items: [ImageModel]
}

// MARK: - ImageModel
struct ImageModel: Identifiable, Codable {
    let albumID, date, id, ownerID: Int
    let postID: Int?
    let sizes: [Size]
    let text: String
    let hasTags: Bool
    let likes: Likes
    let reposts: Reposts
    let lat, long: Double?

    enum CodingKeys: String, CodingKey {
        case albumID = "album_id"
        case date, id
        case ownerID = "owner_id"
        case postID = "post_id"
        case sizes, text
        case hasTags = "has_tags"
        case likes, reposts, lat, long
    }
}

// MARK: - Likes
struct Likes: Codable {
    let userLikes, count: Int

    enum CodingKeys: String, CodingKey {
        case userLikes = "user_likes"
        case count
    }
}

// MARK: - Reposts
struct Reposts: Codable {
    let count: Int
}

// MARK: - Size
struct Size: Codable {
    let height: Int
    let url: String
    let type: TypeEnum
    let width: Int
}

enum TypeEnum: String, Codable {
    case m = "m"
    case o = "o"
    case p = "p"
    case q = "q"
    case r = "r"
    case s = "s"
    case w = "w"
    case x = "x"
    case y = "y"
    case z = "z"
}

struct LikeResponse: Codable {
    let response: LikesResp
}

struct LikesResp: Codable {
    let likes: Int
}

