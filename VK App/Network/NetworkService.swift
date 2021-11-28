//
//  NetworkService.swift
//  VK App
//
//  Created by Lev Bazhkov on 18.06.2021.
//

import UIKit
import Alamofire
import DynamicJSON

final class NetworkService {

    let url =  "https://api.vk.com"
    let token = Session.shared.token
    let userId = Session.shared.userId
    let version = "5.131"
    let ownerID = 0
    let queue = DispatchQueue.global()
    
    func getPhotos(for ownerID: String?, completion: @ escaping ([VKImage])->()) {
        let path = "/method/photos.getAll"
        guard let owner = ownerID else { return }
        let parameters: Parameters = [
            "user_id": userId,
            "owner_id": owner,
            "count": 2,
            "extended": 1,
            "access_token": token,
            "v": version
        ]
        DispatchQueue.global().async {
            AF.request(self.url + path, method: .get, parameters: parameters).responseData(queue: self.queue, completionHandler: { response in
                
                guard let data = response.data else { return }
                //print(data.prettyJSON as Any)
                guard let items = JSON(data).response.items.array else { return }
                let photos: [VKImage] = items.map { VKImage(data: $0) }
                
                DispatchQueue.main.async {
                    completion(photos)
                }
            })
        }
    }
    
    func getGroupsSearch(completion: @ escaping ([VKGroup])->()) {
        let path = "/method/groups.search"
        let parameters: Parameters = [
            "user_id": userId,
            "q": "bmw",
            "fields": "description",
            "access_token": token,
            "v": version
        ]
        DispatchQueue.global().async {
            AF.request(self.url + path, method: .get, parameters: parameters).responseData(queue: self.queue, completionHandler: { response in
                
                guard let data = response.data else { return }
                //print(data.prettyJSON as Any)
                guard let items = JSON(data).response.items.array else { return }
                let groups: [VKGroup] = items.map { VKGroup(data: $0) }
                
                DispatchQueue.main.async {
                    completion(groups)
                }
            })
        }
    }
    
    func getFeedNewsAndGroups(completion: @ escaping ([VKFeed], [VKFeedGroup], String) -> ()) {
        let path = "/method/newsfeed.get"
        let parameters: Parameters = [
            "user_id": userId,
            "access_token": token,
            "v": version,
            "filters": "post",
            "max_photos": 1,
            "source_ids": "groups, pages",
            "count": 10
        ]
        DispatchQueue.global().async {
            AF.request(self.url + path, method: .get, parameters: parameters).responseData(queue: self.queue, completionHandler: { response in
                
                guard let data = response.data else { return }
                //print(data.prettyJSON as Any)
                guard let items = JSON(data).response.items.array else { return }
                guard let itemsGroups = JSON(data).response.groups.array else { return }
                guard let nextFrom = JSON(data).response.next_from.string else { return }
                let news: [VKFeed] = items.map { VKFeed(data: $0) }
                let groups: [VKFeedGroup] = itemsGroups.map({ VKFeedGroup(data: $0) })
                
                DispatchQueue.main.async {
                    completion(news, groups, nextFrom)
                }
            })
        }
    }
    
    func getFeedNewsAndGroupsWithDate(startTime: Int, completion: @escaping ([VKFeed], [VKFeedGroup]) -> ()) {
        let path = "/method/newsfeed.get"
        let parameters: Parameters = [
            "user_id": userId,
            "access_token": token,
            "v": version,
            "filters": "post",
            "max_photos": 1,
            "source_ids": "groups, pages",
            "count": 10,
            "start_time": startTime,
        ]
        DispatchQueue.global().async {
            AF.request(self.url + path, method: .get, parameters: parameters).responseData(queue: self.queue, completionHandler: { response in
                
                guard let data = response.data else { return }
                //print(data.prettyJSON as Any)
                guard let items = JSON(data).response.items.array else { return }
                guard let itemsGroups = JSON(data).response.groups.array else { return }
                let news: [VKFeed] = items.map { VKFeed(data: $0) }
                let groups: [VKFeedGroup] = itemsGroups.map({ VKFeedGroup(data: $0) })
                
                DispatchQueue.main.async {
                    completion(news, groups)
                }
            })
        }
    }
    
    func newsRequest(startFrom: String = "",
                     startTime: Double? = nil,
                     completion: @escaping ([VKFeed], [VKFeedGroup], String) -> Void) {
          
           let path = "/method/newsfeed.get"
           let params: Parameters = [
               "access_token": Session.shared.token,
               "filters": "post",
               "v": version,
               "count": 10,
               "start_from": startFrom
           ]
           AF.request(url + path, method: .get, parameters: params).responseJSON(queue: queue) { response in
                   guard let data = response.data else { return }
                   guard let items = JSON(data).response.items.array else { return }
                   guard let itemsGroups = JSON(data).response.groups.array else { return }
                   guard let nextFrom = JSON(data).response.next_from.string else { return }
                  
                   let parsingGroup = DispatchGroup()
                   parsingGroup.notify(queue: .global()) {
                   let news: [VKFeed] = items.map { VKFeed(data: $0) }
                   let groups: [VKFeedGroup] = itemsGroups.map { VKFeedGroup(data: $0) }

                       DispatchQueue.main.async {
                           completion(news, groups, nextFrom)
                       }
                   }
               }
           }
}
