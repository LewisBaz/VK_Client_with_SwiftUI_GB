//
//  VKGruop.swift
//  VK App
//
//  Created by Lev Bazhkov on 28.04.2021.
//

import UIKit
import RealmSwift
import DynamicJSON
import Firebase

class VKGroup: Object {
    
    @objc dynamic var id, isClosed, isAdvertiser: String?
    @objc dynamic var itemDescription, type: String?
    @objc dynamic var isMember: String?
    @objc dynamic var photo50, photo200, photo100: String?
    @objc dynamic var isAdmin: String?
    @objc dynamic var name, screenName: String?
    
    convenience required init(data: JSON) {
        self.init()
        self.id = data.id.string
        self.isClosed = data.is_closed.string
        self.isAdvertiser = data.is_advertiser.string
        self.itemDescription = data.description
        self.type = data.type.string
        self.isMember = data.is_member.string
        self.photo50 = data.photo_50.string
        self.photo100 = data.photo_100.string
        self.photo200 = data.photo_200.string
        self.isAdmin = data.is_admin.string
        self.name = data.name.string
        self.screenName = data.screen_name.string
    }
    
    override static func primaryKey() -> String? {
           return "id"
       }
}

class FirebaseVKGroup {
    
    let name: String
    let id: Int
    let ref: DatabaseReference?
    
    init(name: String, id: Int) {
        self.ref = nil
        self.name = name
        self.id = id
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: Any],
            let id = value["id"] as? Int,
            let name = value["name"] as? String else {
        return nil
    }
        self.ref = snapshot.ref
        self.id = id
        self.name = name
    }
    
    func toAnyObject() -> [AnyHashable: Any] {
        
        return [
            "name": name,
            "id": id
        ] as [AnyHashable: Any]
    }
}
