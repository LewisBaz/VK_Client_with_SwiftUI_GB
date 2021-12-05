//
//  ImageModel.swift
//  VK_Client_SwiftUI
//
//  Created by Lewis on 06.12.2021.
//

import Foundation
import SwiftUI

class ImageModel: Identifiable {
    
    let id: UUID = UUID()
    let image: Image
    
    init(image: Image) {
        self.image = image
    }
}

