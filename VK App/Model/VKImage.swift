//
//  VKImage.swift
//  VK App
//
//  Created by Lev Bazhkov on 20.05.2021.
//

import UIKit
import RealmSwift
import DynamicJSON

class VKImage: Object {
    
    @objc dynamic var id: String?
    @objc dynamic var image: String?
    @objc dynamic var isLiked, count: String?
    @objc dynamic var repostsCount: String?
    @objc dynamic var date, ownerId, postId: String?
    @objc dynamic var text: String?
    @objc dynamic var hasTags: String?
    @objc dynamic var albumId: String?
    
    convenience required init(data: JSON) {
        self.init()
        self.id = data.id.string
        self.image = data.sizes[6].url.string
        self.isLiked = data.likes.user_likes.string
        self.count = data.likes.count.string
        self.repostsCount = data.reposts.count.string
        self.date = data.date.string
        self.ownerId = data.owner_id.string
        self.postId = data.post_id.string
        self.text = data.text.string
        self.hasTags = data.has_tags.string
        self.albumId = data.album_id.string
    }
    
    override static func primaryKey() -> String? {
           return "id"
       }
}
