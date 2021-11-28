//
//  ServiceProxy.swift
//  VK App
//
//  Created by Lewis on 15.11.2021.
//

import Foundation

class ServiceProxy {
    
    let networkService: NetworkService
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getPhotos(for ownerID: String?, completion: @ escaping ([VKImage])->()) {
        self.networkService.getPhotos(for: ownerID, completion: completion)
        print("Получаем фотографии пользователя по id")
    }
    
    func getGroupsSearch(completion: @ escaping ([VKGroup])->()) {
        self.networkService.getGroupsSearch(completion: completion)
        print("Получаем группы по поисковому запросу")
    }
    
    func getFeedNewsAndGroups(completion: @ escaping ([VKFeed], [VKFeedGroup], String) -> ()) {
        self.networkService.getFeedNewsAndGroups(completion: completion)
        print("Получаем новости и их источники")
    }
    
    func getFeedNewsAndGroupsWithDate(startTime: Int, completion: @escaping ([VKFeed], [VKFeedGroup]) -> ()) {
        self.networkService.getFeedNewsAndGroupsWithDate(startTime: startTime, completion: completion)
        print("Получаем новости и их источники для подгрузки данных в начало ленты")
    }
    
    func newsRequest(startFrom: String = "",
                     startTime: Double? = nil,
                     completion: @escaping ([VKFeed], [VKFeedGroup], String) -> Void) {
        self.networkService.newsRequest(startFrom: startFrom, startTime: startTime, completion: completion)
        print("Получаем новости и их источники для подгрузки данных в конец ленты")
    }
}
