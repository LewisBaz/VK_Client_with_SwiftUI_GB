//
//  CommentControl.swift
//  VK App
//
//  Created by Lev Bazhkov on 08.05.2021.
//

import UIKit

@IBDesignable final class CommentControl: UIControl {
            
    var isTapped: Bool = false
    
    var commentButton = UIButton(type: .custom)
    var commentImage = UIImageView()
    
    var commentsCount: Int = 0 {
        didSet {
            commentButton.setTitle("\(commentsCount)", for: .normal)
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
        commentButton.contentMode = .center
        commentButton.setTitle("\(commentsCount)", for: .normal)
        commentButton.setTitleColor(.darkGrayUIColor, for: .normal)
        commentButton.setImage(UIImage(systemName: "bubble.left"), for: .normal)
        commentButton.tintColor = .darkGrayUIColor
        commentButton.addTarget(self, action: #selector(buttonAction(_ :)), for: .touchUpInside)
        self.addSubview(commentButton)
    }
    
    @objc private func buttonAction(_ sender: UIButton) {
        isTapped.toggle()
        if isTapped == false {
            commentButton.tintColor = .darkGrayUIColor
            commentButton.setTitleColor(.darkGrayUIColor, for: .normal)
        } else {
            commentButton.tintColor = .blackUIColor
            commentButton.setTitleColor(.blackUIColor, for: .normal)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        commentButton.frame = bounds
    }
}
