//
//  AllGroupsTableViewCell.swift
//  VK App
//
//  Created by Lev Bazhkov on 28.04.2021.
//

import UIKit

final class AllGroupsTableViewCell: UITableViewCell {

    static let reuseIdentifier = "AllGroupsTableViewCell"
    
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet private weak var avatarView: AvatarImageShadowView!
    @IBOutlet weak var groupImage: AvatarImage!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with viewModel: GroupCellModel) {
        groupName.text = viewModel.groupName
        groupImage.image = viewModel.groupImage
    }
}
