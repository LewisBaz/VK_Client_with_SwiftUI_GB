//
//  ImageViewModel.swift
//  VK_Client_SwiftUI
//
//  Created by Lewis on 27.12.2021.
//

import Foundation

class ImageViewModel: ObservableObject {
    
    let networkService: NetworkService
    let ownerId: String
    
    @Published var images: [ImageModel] = []
    
    init(networkService: NetworkService, ownerId: String) {
        self.networkService = networkService
        self.ownerId = ownerId
    }
    
    public func getImages() {
        networkService.getPhotos(for: ownerId, completion: { [weak self] images in
            guard let self = self else { return }
            self.images = images
        })
    }
}
