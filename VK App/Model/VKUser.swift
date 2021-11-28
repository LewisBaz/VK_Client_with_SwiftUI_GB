//
//  VKUser.swift
//  VK App
//
//  Created by Lev Bazhkov on 28.04.2021.
//

import UIKit
import RealmSwift
import DynamicJSON

class VKUser: Object {

     @objc dynamic var userId: String?
     @objc dynamic var lastName: String?
     @objc dynamic var firstName: String?
     @objc dynamic var photo50: String?

     convenience required init(data: JSON) {
         self.init()
         self.userId = data.id.string
         self.lastName = data.last_name.string
         self.firstName = data.first_name.string
         self.photo50 = data.photo_50.string
     }
    
    override static func primaryKey() -> String? {
           return "userId"
       }
}
