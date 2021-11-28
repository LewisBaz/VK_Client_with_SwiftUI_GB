//
//  DatabaseService.swift
//  VK App
//
//  Created by Lev Bazhkov on 03.07.2021.
//

import UIKit
import RealmSwift

protocol DatabaseServiceProtocol {
    
    func add(user: VKUser)
    func readUser() -> [VKUser]
    func delete(user: VKUser, userId: String)
    func deleteAll(users: [VKUser])
    
    func add(group: VKGroup)
    func readGroup() -> [VKGroup]
    func delete(group: VKGroup, id: String)
    func deleteAll(groups: [VKGroup])
    
    func add(image: VKImage)
    func readImage() -> [VKImage]
    func delete(image: VKImage, id: String)
    func deleteAll(images: [VKImage])
 }

final class DatabaseService: DatabaseServiceProtocol {
    
    var config = Realm.Configuration(schemaVersion: 8)
    lazy var realm = try! Realm(configuration: config)
    
    //MARK: VKUser
    
    func add(user: VKUser) {
        do {
            realm.beginWrite()
            realm.add(user)
            try realm.commitWrite()
            print(realm.configuration.fileURL as Any)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func readUser() -> [VKUser] {
        let users = realm.objects(VKUser.self)
        return Array(users)
    }
    
    func delete(user: VKUser, userId: String) {
        do {
            realm.beginWrite()
            let object = realm.objects(VKUser.self).filter("userId = '\(userId)'")
            realm.delete(object)
            try realm.commitWrite()
            print(realm.configuration.fileURL as Any)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteAll(users: [VKUser]) {
        do {
            realm.beginWrite()
            realm.delete(realm.objects(VKUser.self))
            try realm.commitWrite()
            print(realm.configuration.fileURL as Any)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: VKGroup
    
    func add(group: VKGroup) {
        do {
            realm.beginWrite()
            realm.add(group)
            try realm.commitWrite()
            print(realm.configuration.fileURL as Any)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func readGroup() -> [VKGroup] {
        let groups = realm.objects(VKGroup.self)
        return Array(groups)
    }
    
    func delete(group: VKGroup, id: String) {
        do {
            realm.beginWrite()
            let object = realm.objects(VKGroup.self).filter("id = '\(id)'")
            realm.delete(object)
            try realm.commitWrite()
            print(realm.configuration.fileURL as Any)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteAll(groups: [VKGroup]) {
        do {
            realm.beginWrite()
            realm.delete(realm.objects(VKGroup.self))
            try realm.commitWrite()
            print(realm.configuration.fileURL as Any)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: VKImage
    
    func add(image: VKImage) {
        do {
            realm.beginWrite()
            realm.add(image)
            try realm.commitWrite()
            print(realm.configuration.fileURL as Any)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func readImage() -> [VKImage] {
        let images = realm.objects(VKImage.self)
        return Array(images)
    }
    
    func delete(image: VKImage, id: String) {
        do {
            realm.beginWrite()
            let object = realm.objects(VKImage.self).filter("id = '\(id)'")
            realm.delete(object)
            try realm.commitWrite()
            print(realm.configuration.fileURL as Any)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteAll(images: [VKImage]) {
        do {
            realm.beginWrite()
            realm.delete(realm.objects(VKImage.self))
            try realm.commitWrite()
            print(realm.configuration.fileURL as Any)
        } catch {
            print(error.localizedDescription)
        }
    }
}
