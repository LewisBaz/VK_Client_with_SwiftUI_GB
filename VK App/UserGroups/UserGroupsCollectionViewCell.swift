//
//  UserGroupsCollectionViewCell.swift
//  VK App
//
//  Created by Lev Bazhkov on 11.05.2021.
//

import UIKit

final class UserGroupsCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "UserGroupsCollectionViewCell"
    
    @IBOutlet weak var userGroupImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userGroupImage.contentMode = .scaleToFill
    }
    
    func configure(with viewModel: GroupCellModel) {
        userGroupImage.image = viewModel.groupImage
    }
}
