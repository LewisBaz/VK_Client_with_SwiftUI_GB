//
//  GroupViewModel.swift
//  VK_Client_SwiftUI
//
//  Created by Lewis on 26.12.2021.
//

import Foundation

class GroupsViewModel: ObservableObject {
    
    let networkService: NetworkService
    
    @Published var groups: [GroupModel] = []
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    public func getGroups() {
        networkService.getGroups(completion: { [weak self] groups in
            guard let self = self else { return }
            self.groups = groups
        })
    }
}
