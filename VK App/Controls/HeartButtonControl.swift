//
//  HeartButtonControl.swift
//  VK App
//
//  Created by Lev Bazhkov on 03.05.2021.
//

import UIKit

@IBDesignable final class HeartButtonControl: UIControl {

    var likeCount: Int = 0 {
        didSet {
            heartButton.setTitle("\(likeCount)", for: .normal)
        }
    }
    var isLiked: Bool = false {
        didSet {
            heartButton.setImage(isLiked ? self.likedImage : self.unlikedImage, for: .normal)
        }
    }
    
    var heartButton = UIButton(type: .custom)
    private var likedImage = UIImage(systemName: "heart.fill")
    private var unlikedImage = UIImage(systemName: "heart")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    func setLike(count: Int) {
        likeCount = count
    }
    
    private func setupView() {
        heartButton.setTitleColor(.red, for: .normal)
        heartButton.tintColor = .red
        heartButton.setTitle("\(likeCount)", for: .normal)
        heartButton.setImage(unlikedImage, for: .normal)
        heartButton.addTarget(self, action: #selector(buttonAction(_ :)), for: .touchUpInside)
        self.addSubview(heartButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heartButton.frame = bounds
    }
    
    @objc private func buttonAction(_ sender: UIButton) {
        isLiked.toggle()
        likeCount = isLiked ? (likeCount + 1) : (likeCount - 1)
        
        if isLiked == true {
            heartButtonAnimation()
        } else {
            heartButtonAnimation()
            return
        }
        
        sendActions(for: .valueChanged)
    }
    
    private func heartButtonAnimation() {
        
        UIView.animateKeyframes(withDuration: 0.2,
                                delay: 0,
                                options: .calculationModeLinear,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/2) {
                                        self.heartButton.alpha = 0
                                    }
                                    UIView.addKeyframe(withRelativeStartTime: 1/2, relativeDuration: 1/2) {
                                        self.heartButton.alpha = 1
                                    }
                                })
    }
}
