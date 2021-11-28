//
//  GroupCellModelFactory.swift
//  VK App
//
//  Created by Lev Bazhkov on 04.09.2021.
//

import UIKit
 
final class GroupCellModelFactory {
    
    func constructViewModels(from groups: [VKGroup]) -> [GroupCellModel] {
        return groups.compactMap(self.viewModel)
    }
    
    func viewModel(from groups: VKGroup) -> GroupCellModel {
        let groupName = String(groups.name ?? "")
        let url = URL(string: groups.photo200 ?? "")
        let data = (try? Data(contentsOf: url!)) ?? Data()
        let groupImage = UIImage(data: data) ?? UIImage()

        return GroupCellModel(groupName: groupName, groupImage: groupImage)
    }
}
