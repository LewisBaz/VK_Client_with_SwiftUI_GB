//
//  AvatarImage.swift
//  VK App
//
//  Created by Lev Bazhkov on 01.05.2021.
//

import UIKit

final class AvatarImage: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.frame.width/2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.darkGrayCGColor
    }
}
