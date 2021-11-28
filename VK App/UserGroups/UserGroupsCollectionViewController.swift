//
//  UserGroupsCollectionViewController.swift
//  VK App
//
//  Created by Lev Bazhkov on 11.05.2021.
//

import UIKit
import SDWebImage

final class UserGroupsCollectionViewController: UICollectionViewController {
    
    var group: GroupCellModel!
    var groupAvatar = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = view.frame.width
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.itemSize = CGSize(width: width, height: width + 10)
    }

    // MARK: - Navigation

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserGroupsCollectionViewCell.reuseIdentifier, for: indexPath) as! UserGroupsCollectionViewCell

        cell.userGroupImage.image = group.groupImage
    
        return cell
    }
}
