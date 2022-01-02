//
//  GroupModel.swift
//  VK_Client_SwiftUI
//
//  Created by Lewis on 10.12.2021.
//

import Foundation

struct GroupResponse: Codable {
    let response: GroupResponseCount
}

struct GroupResponseCount: Codable {
    let count: Int
    let items: [GroupModel]
}

struct GroupModel: Identifiable, Codable {
    
    var id: Int
    var groupName: String
    var image: String
    
    init(id: Int, groupName: String, image: String) {
        self.id = id
        self.groupName = groupName
        self.image = image
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case groupName = "name"
        case image = "photo_200"
    }
    
}
