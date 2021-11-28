//
//  AvatarImageViewController.swift
//  VK App
//
//  Created by Lev Bazhkov on 30.04.2021.
//

import UIKit

final class AvatarImageShadowView: UIView {
    
    @IBInspectable private var shadowColor: UIColor = .darkGrayUIColor
    @IBInspectable private var shadowOpacity: CGFloat = 0.5
    @IBInspectable private var shadowRadius: CGFloat = 4.0
    @IBInspectable private var shadowOffset: CGSize = CGSize.zero

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowOpacity = Float(shadowOpacity)
        self.layer.shadowRadius = CGFloat(shadowRadius)
        self.layer.cornerRadius = self.frame.width/2 
    }
}
