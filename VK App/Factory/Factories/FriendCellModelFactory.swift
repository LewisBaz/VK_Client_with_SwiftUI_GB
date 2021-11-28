//
//  FriendCellModelFactory.swift
//  VK App
//
//  Created by Lev Bazhkov on 04.09.2021.
//

import UIKit
import RealmSwift
 
final class FriendCellModelFactory {
    
    func constructViewModels(from users: [VKUser]) -> [FriendCellModel] {
        return users.compactMap(self.viewModel)
    }
    
    func viewModel(from users: VKUser) -> FriendCellModel {
        let userFirstName = String(users.firstName ?? "")
        let userLastName = String(users.lastName ?? "")
        let url = URL(string: users.photo50 ?? "")
        let data = (try? Data(contentsOf: url!)) ?? Data()
        let userImage = UIImage(data: data) ?? UIImage()
        let userId = String(users.userId ?? "")
        
        return FriendCellModel(userFirstName: userFirstName, userLastName: userLastName, userImage: userImage, userId: userId)
    }
}
