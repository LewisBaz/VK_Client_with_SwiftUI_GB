//
//  UserModel.swift
//  VK_Client_SwiftUI
//
//  Created by Lewis on 06.12.2021.
//

import Foundation
import SwiftUI

class UserModel: Identifiable {
    
    let id: UUID = UUID()
    let image: Image
    let firstName: String
    let lastName: String
    
    init(image: Image, firstName: String, lastname: String) {
        self.image = image
        self.firstName = firstName
        self.lastName = lastname
    }
}
