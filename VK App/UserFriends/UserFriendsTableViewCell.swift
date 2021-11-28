//
//  UserFriendsTableViewCell.swift
//  VK App
//
//  Created by Lev Bazhkov on 28.04.2021.
//

import UIKit

final class UserFriendsTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "UserFriendsTableViewCell"
    
    @IBOutlet private weak var avatarView: AvatarImageShadowView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: AvatarImage!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with viewModel: FriendCellModel) {
        userName.text = viewModel.userFirstName + " " + viewModel.userLastName
        userImage.image = viewModel.userImage
    }
}
