//
//  UserModel.swift
//  VK_Client_SwiftUI
//
//  Created by Lewis on 06.12.2021.
//

import Foundation

struct UserResponse: Codable {
    let response: UserResponseCount
}

struct UserResponseCount: Codable {
    let count: Int
    let items: [UserModel]
}

struct UserModel: Identifiable, Codable {
    
    let id: Int
    let image: String
    let firstName: String
    let lastName: String
    
    init(id: Int, image: String, firstName: String, lastName: String) {
        self.id = id
        self.image = image
        self.firstName = firstName
        self.lastName = lastName
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case image = "photo_50"
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

