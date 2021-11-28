//
//  UserGroupsTableViewCell.swift
//  VK App
//
//  Created by Lev Bazhkov on 28.04.2021.
//

import UIKit

final class UserGroupsTableViewCell: UITableViewCell {

    static let reuseIdentifier = "UserGroupsTableViewCell"
    
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupImage: AvatarImage!
    @IBOutlet private weak var avatarView: AvatarImageShadowView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with viewModel: GroupCellModel) {
        groupName.text = viewModel.groupName
        groupImage.image = viewModel.groupImage
    }
}
