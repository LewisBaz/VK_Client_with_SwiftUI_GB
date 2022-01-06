//
//  NetworkService.swift
//  VK App
//
//  Created by Lev Bazhkov on 18.06.2021.
//

import UIKit

final class NetworkService {

    let url =  "https://api.vk.com"
    let token: String = UserDefaults.standard.object(forKey: "vkToken") as! String
    let userId = UserDefaults.standard.object(forKey: "vkTokenSaved") as! String
    let version = "5.131"
    let ownerID = 0
    private let queue = DispatchQueue(label: "networkQueue", qos: .userInitiated)
    
    func getFriends(completion: @escaping ([UserModel]) -> ()) {
        
        let path = "/method/friends.get"
        var components = URLComponents(string: self.url + path)
        components?.queryItems = [
            URLQueryItem(name: "user_id", value: self.userId),
            URLQueryItem(name: "order", value: "name"),
            URLQueryItem(name: "fields", value: "photo_50"),
            URLQueryItem(name: "access_token", value: self.token),
            URLQueryItem(name: "v", value: self.version)
        ]
        let request = URLRequest(url: (components?.url!)!)
        
        queue.async {
            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                guard let data = data else { return }
//                      let json = try? JSONSerialization.jsonObject(with: data) else { return }
//                      print(json)
                do {
                    let results = try JSONDecoder().decode(UserResponse.self, from: data)
                    let users = results.response.items.map({$0})
                    DispatchQueue.main.async {
                        completion(users)
                    }
                } catch {
                    print(error)
                }
            })
            task.resume()
        }
    }
    
    func getGroups(completion: @escaping ([GroupModel]) -> ()) {
        
        let path = "/method/groups.get"
        var components = URLComponents(string: self.url + path)
        components?.queryItems = [
            URLQueryItem(name: "user_id", value: self.userId),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "fields", value: "description"),
            URLQueryItem(name: "access_token", value: self.token),
            URLQueryItem(name: "v", value: self.version)
        ]
        let request = URLRequest(url: (components?.url!)!)
        
        queue.async {
            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                guard let data = data else { return }
//                      let json = try? JSONSerialization.jsonObject(with: data) else { return }
//                      print(json)
                do {
                    let results = try JSONDecoder().decode(GroupResponse.self, from: data)
                    let groups = results.response.items.map({$0})
                    DispatchQueue.main.async {
                        completion(groups)
                    }
                } catch {
                    print(error)
                }
            })
            task.resume()
        }
    }
    
    func getPhotos(for ownerID: String?, completion: @escaping ([ImageModel])->()) {
        let path = "/method/photos.getAll"
        guard let owner = ownerID else { return }
        var components = URLComponents(string: self.url + path)
        components?.queryItems = [
            URLQueryItem(name: "user_id", value: self.userId),
            URLQueryItem(name: "owner_id", value: owner),
            URLQueryItem(name: "count", value: "100"),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "access_token", value: self.token),
            URLQueryItem(name: "v", value: self.version)
        ]
        let request = URLRequest(url: (components?.url!)!)
        
        queue.async {
            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                
                guard let data = data else { return }
//                      let json = try? JSONSerialization.jsonObject(with: data) else { return }
//                print(json)
                do {
                    let results = try JSONDecoder().decode(ImageResponse.self, from: data)
                    let images = results.response.items.map({$0})
                    DispatchQueue.main.async {
                        completion(images)
                    }
                } catch {
                    print(error)
                }
            })
            task.resume()
        }
    }
    
    func addLike(ownerId: String?, itemId: String?) {
        let path = "/method/likes.add"
        guard let owner = ownerId else { return }
        guard let item = itemId else { return }
        var components = URLComponents(string: self.url + path)
        components?.queryItems = [
            URLQueryItem(name: "user_id", value: self.userId),
            URLQueryItem(name: "type", value: "photo"),
            URLQueryItem(name: "owner_id", value: owner),
            URLQueryItem(name: "item_id", value: item),
            URLQueryItem(name: "access_token", value: self.token),
            URLQueryItem(name: "v", value: self.version)
        ]
        let request = URLRequest(url: (components?.url!)!)
        
        queue.async {
            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                
                guard let data = data else { return }
//                      let json = try? JSONSerialization.jsonObject(with: data) else { return }
//                print(json)
                do {
                    let results = try JSONDecoder().decode(LikeResponse.self, from: data)
                    let likes = results.response.likes
                    print("success add like, total likes count \(likes)")
                } catch {
                    print(error)
                }
            })
            task.resume()
        }
    }
    
    func removeLike(ownerId: String?, itemId: String?) {
        let path = "/method/likes.delete"
        guard let owner = ownerId else { return }
        guard let item = itemId else { return }
        var components = URLComponents(string: self.url + path)
        components?.queryItems = [
            URLQueryItem(name: "user_id", value: self.userId),
            URLQueryItem(name: "type", value: "photo"),
            URLQueryItem(name: "owner_id", value: owner),
            URLQueryItem(name: "item_id", value: item),
            URLQueryItem(name: "access_token", value: self.token),
            URLQueryItem(name: "v", value: self.version)
        ]
        let request = URLRequest(url: (components?.url!)!)
        
        queue.async {
            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                
                guard let data = data else { return }
//                      let json = try? JSONSerialization.jsonObject(with: data) else { return }
//                print(json)
                do {
                    let results = try JSONDecoder().decode(LikeResponse.self, from: data)
                    let likes = results.response.likes
                    print("success remove like, total likes count \(likes)")
                } catch {
                    print(error)
                }
            })
            task.resume()
        }
    }
}
