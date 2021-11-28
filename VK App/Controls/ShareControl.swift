//
//  ShareControl.swift
//  VK App
//
//  Created by Lev Bazhkov on 08.05.2021.
//

import UIKit

@IBDesignable final class ShareControl: UIControl {
    
    var isTapped: Bool = false
    
    var shareButton = UIButton(type: .custom)
    var shareImage = UIImage(systemName: "arrowshape.turn.up.right")
    
    var sharesCount: Int = 0 {
        didSet {
            shareButton.setTitle("\(sharesCount)", for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    private func setupView() {
        shareButton.contentMode = .center
        shareButton.setTitle("\(sharesCount)", for: .normal)
        shareButton.setTitleColor(.darkGrayUIColor, for: .normal)
        shareButton.setImage(shareImage, for: .normal)
        shareButton.tintColor = .darkGrayUIColor
        shareButton.addTarget(self, action: #selector(buttonAction(_ :)), for: .touchUpInside)
        self.addSubview(shareButton)
    }
    
    @objc private func buttonAction(_ sender: UIButton) {
        isTapped.toggle()
        if isTapped == false {
            shareButton.tintColor = .darkGrayUIColor
            shareButton.setTitleColor(.darkGrayUIColor, for: .normal)
        } else {
            shareButton.tintColor = .blackUIColor
            shareButton.setTitleColor(.blackUIColor, for: .normal)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shareButton.frame = bounds
    }
}
