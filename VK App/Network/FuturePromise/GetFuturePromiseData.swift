//
//  GetFuturePromiseData.swift
//  VK App
//
//  Created by Lev Bazhkov on 12.08.2021.
//

import UIKit
import Alamofire
import DynamicJSON
import PromiseKit
import RealmSwift

enum NetworkError: Error {
    case empty
}

class GetFuturePromiseData {
    
    let url =  "https://api.vk.com"
    let token = Session.shared.token
    let userId = Session.shared.userId
    let version = "5.131"

    @discardableResult
    func getFriends(on queue: DispatchQueue) -> Promise<[VKUser]> {

        let path = "/method/friends.get"
        let parameters: Parameters = [
            "user_id": userId,
            "order": "name",
            "fields": "photo_50",
            "access_token": token,
            "v": version
        ]

        let promise = Promise<[VKUser]>()
        
        AF.request(url + path, method: .get, parameters: parameters).responseJSON(completionHandler: { response in

            if let error = response.error {
                promise.reject(with: error)
            } else if let data = response.data {
                guard let items = JSON(data).response.items.array else { return }
                let friends: [VKUser] = items.map { VKUser(data: $0) }
                promise.fulfill(with: friends)
            } else {
                promise.reject(with: NetworkError.empty)
            }
        })
        return promise
    }
}

