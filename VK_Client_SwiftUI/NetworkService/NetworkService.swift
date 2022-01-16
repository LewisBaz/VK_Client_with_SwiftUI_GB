//
//  NetworkService.swift
//  VK App
//
//  Created by Lev Bazhkov on 18.06.2021.
//

import UIKit

final class NetworkService {

    let url =  "https://api.vk.com"
    let token = Session.shared.token
    let userId = Session.shared.userId
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
    
    func getPhotos(for ownerID: String?, completion: @ escaping ([ImageModel])->()) {
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
    
//    func getGroupsSearch(completion: @ escaping ([VKGroup])->()) {
//        let path = "/method/groups.search"
//        let parameters: Parameters = [
//            "user_id": userId,
//            "q": "bmw",
//            "fields": "description",
//            "access_token": token,
//            "v": version
//        ]
//        DispatchQueue.global().async {
//            AF.request(self.url + path, method: .get, parameters: parameters).responseData(queue: self.queue, completionHandler: { response in
//
//                guard let data = response.data else { return }
//                //print(data.prettyJSON as Any)
//                guard let items = JSON(data).response.items.array else { return }
//                let groups: [VKGroup] = items.map { VKGroup(data: $0) }
//
//                DispatchQueue.main.async {
//                    completion(groups)
//                }
//            })
//        }
//    }
//
//    func getFeedNewsAndGroups(completion: @ escaping ([VKFeed], [VKFeedGroup], String) -> ()) {
//        let path = "/method/newsfeed.get"
//        let parameters: Parameters = [
//            "user_id": userId,
//            "access_token": token,
//            "v": version,
//            "filters": "post",
//            "max_photos": 1,
//            "source_ids": "groups, pages",
//            "count": 10
//        ]
//        DispatchQueue.global().async {
//            AF.request(self.url + path, method: .get, parameters: parameters).responseData(queue: self.queue, completionHandler: { response in
//
//                guard let data = response.data else { return }
//                //print(data.prettyJSON as Any)
//                guard let items = JSON(data).response.items.array else { return }
//                guard let itemsGroups = JSON(data).response.groups.array else { return }
//                guard let nextFrom = JSON(data).response.next_from.string else { return }
//                let news: [VKFeed] = items.map { VKFeed(data: $0) }
//                let groups: [VKFeedGroup] = itemsGroups.map({ VKFeedGroup(data: $0) })
//
//                DispatchQueue.main.async {
//                    completion(news, groups, nextFrom)
//                }
//            })
//        }
//    }
//
//    func getFeedNewsAndGroupsWithDate(startTime: Int, completion: @escaping ([VKFeed], [VKFeedGroup]) -> ()) {
//        let path = "/method/newsfeed.get"
//        let parameters: Parameters = [
//            "user_id": userId,
//            "access_token": token,
//            "v": version,
//            "filters": "post",
//            "max_photos": 1,
//            "source_ids": "groups, pages",
//            "count": 10,
//            "start_time": startTime,
//        ]
//        DispatchQueue.global().async {
//            AF.request(self.url + path, method: .get, parameters: parameters).responseData(queue: self.queue, completionHandler: { response in
//
//                guard let data = response.data else { return }
//                //print(data.prettyJSON as Any)
//                guard let items = JSON(data).response.items.array else { return }
//                guard let itemsGroups = JSON(data).response.groups.array else { return }
//                let news: [VKFeed] = items.map { VKFeed(data: $0) }
//                let groups: [VKFeedGroup] = itemsGroups.map({ VKFeedGroup(data: $0) })
//
//                DispatchQueue.main.async {
//                    completion(news, groups)
//                }
//            })
//        }
//    }
//
//    func newsRequest(startFrom: String = "",
//                     startTime: Double? = nil,
//                     completion: @escaping ([VKFeed], [VKFeedGroup], String) -> Void) {
//
//           let path = "/method/newsfeed.get"
//           let params: Parameters = [
//               "access_token": Session.shared.token,
//               "filters": "post",
//               "v": version,
//               "count": 10,
//               "start_from": startFrom
//           ]
//           AF.request(url + path, method: .get, parameters: params).responseJSON(queue: queue) { response in
//                   guard let data = response.data else { return }
//                   guard let items = JSON(data).response.items.array else { return }
//                   guard let itemsGroups = JSON(data).response.groups.array else { return }
//                   guard let nextFrom = JSON(data).response.next_from.string else { return }
//
//                   let parsingGroup = DispatchGroup()
//                   parsingGroup.notify(queue: .global()) {
//                   let news: [VKFeed] = items.map { VKFeed(data: $0) }
//                   let groups: [VKFeedGroup] = itemsGroups.map { VKFeedGroup(data: $0) }
//
//                       DispatchQueue.main.async {
//                           completion(news, groups, nextFrom)
//                       }
//                   }
//               }
//           }
}
