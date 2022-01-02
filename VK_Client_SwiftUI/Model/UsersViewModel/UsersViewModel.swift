//
//  UsersViewModel.swift
//  VK_Client_SwiftUI
//
//  Created by Lewis on 12.12.2021.
//

import Foundation

class UsersViewModel: ObservableObject {
    
    let networkService: NetworkService
    
    @Published var users: [UserModel] = []
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    public func getUsers() {
        networkService.getFriends(completion: { [weak self] users in
            guard let self = self else { return }
            self.users = users
        })
    }
}
