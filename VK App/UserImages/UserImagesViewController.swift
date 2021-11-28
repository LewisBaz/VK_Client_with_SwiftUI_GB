//
//  UserImagesViewController.swift
//  VK App
//
//  Created by Lev Bazhkov on 20.05.2021.
//

import UIKit

final class UserImagesViewController: UIViewController {
    
    var imageViewOne = UIImageView()
    var imageViewTwo = UIImageView()
    var likeControlOne = HeartButtonControl()
    var likeControlTwo = HeartButtonControl()
    
    private var propertyAnimatorRight: UIViewPropertyAnimator!
    private var propertyAnimatorLeft: UIViewPropertyAnimator!
    private var propertyAnimatorDown: UIViewPropertyAnimator!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemTeal
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(changeView))
        view.addGestureRecognizer(panGestureRecognizer)
        
        view.addSubview(imageViewOne)
        imageViewOne.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageViewTwo)
        imageViewTwo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(likeControlOne)
        likeControlOne.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(likeControlTwo)
        likeControlTwo.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageViewOne.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageViewOne.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageViewOne.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            imageViewOne.heightAnchor.constraint(equalToConstant: view.frame.width),
            imageViewOne.widthAnchor.constraint(equalToConstant: view.frame.width),
            
            imageViewTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageViewTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageViewTwo.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            imageViewTwo.heightAnchor.constraint(equalToConstant: view.frame.width),
            imageViewTwo.widthAnchor.constraint(equalToConstant: view.frame.width),
            
            likeControlOne.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            likeControlOne.widthAnchor.constraint(equalToConstant: 50),
            likeControlOne.topAnchor.constraint(equalTo: imageViewOne.bottomAnchor),
            likeControlOne.heightAnchor.constraint(equalToConstant: 30),
            
            likeControlTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            likeControlTwo.widthAnchor.constraint(equalToConstant: 50),
            likeControlTwo.topAnchor.constraint(equalTo: imageViewOne.bottomAnchor),
            likeControlTwo.heightAnchor.constraint(equalToConstant: 30),
        ])
        imageViewTwo.alpha = 0
        likeControlTwo.alpha = 0
        let trans = CGAffineTransform(translationX: 500, y: 0)
        let scale = CGAffineTransform(scaleX: 0.7, y: 0.7)
        self.imageViewTwo.transform = trans.concatenating(scale)
        
        imageViewOne.contentMode = .scaleAspectFit
        imageViewTwo.contentMode = .scaleAspectFit
    }
    
    @objc private func changeView(recognizer: UIPanGestureRecognizer) {
        
        let scaleImageViewOne = CGAffineTransform(scaleX: 0.7, y: 0.7)
        let translationImageViewOne = CGAffineTransform(translationX: -400, y: 0)
        let transformImageViewOne = scaleImageViewOne.concatenating(translationImageViewOne)
        
        let scaleImageViewTwo = CGAffineTransform(scaleX: 0.7, y: 0.7)
        let translationImageViewTwo = CGAffineTransform(translationX: 400, y: 0)
        let transformImageViewTwo = scaleImageViewTwo.concatenating(translationImageViewTwo)
        
        switch recognizer.state {
        case .began:
            propertyAnimatorRight = UIViewPropertyAnimator(
                duration: 1,
                curve: .easeInOut,
                animations: {
                        self.likeControlOne.alpha = 0
                        self.likeControlTwo.alpha = 1
                    
                    UIView.animate(withDuration: 2,
                                   delay: 0,
                                   options: []) {
                        self.imageViewOne.alpha = 0
                        self.imageViewTwo.alpha = 1
                        self.imageViewOne.transform = transformImageViewOne
                    }
                    self.imageViewTwo.transform = .identity
            })
            
            propertyAnimatorLeft = UIViewPropertyAnimator(
                duration: 1,
                curve: .easeInOut,
                animations: {
                    self.likeControlOne.alpha = 1
                    self.likeControlTwo.alpha = 0
                    
                    UIView.animate(withDuration: 2,
                                   delay: 0,
                                   options: []) {
                        self.imageViewOne.alpha = 1
                        self.imageViewTwo.alpha = 0
                        self.imageViewTwo.transform = transformImageViewTwo
                    }
                    self.imageViewOne.transform = .identity
                })
            
            propertyAnimatorDown = UIViewPropertyAnimator(
                duration: 2,
                curve: .easeInOut,
                animations: {
                    self.imageViewOne.alpha = 0
                    self.imageViewTwo.alpha = 0
                    self.likeControlOne.alpha = 0
                    self.likeControlTwo.alpha = 0
                    let scale = CGAffineTransform(scaleX: 0.3, y: 0.3)
                    self.imageViewOne.transform = scale
                    self.imageViewTwo.transform = scale
                    self.likeControlOne.transform = scale
                    self.likeControlTwo.transform = scale
                })
            
        case .changed:
            let translationX = recognizer.translation(in: self.view).x
            let translationY = recognizer.translation(in: self.view).y
                if translationX < 0 {
                    propertyAnimatorRight.fractionComplete = abs(translationX)/100
                } else if translationX > 0 {
                    propertyAnimatorLeft.fractionComplete = abs(translationX)/100
                } else if translationY > 0 {
                    propertyAnimatorDown.fractionComplete = abs(translationY)/100
                    self.navigationController?.popViewController(animated: true)
                }
            
        case .ended:
            propertyAnimatorRight.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            propertyAnimatorLeft.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            propertyAnimatorDown.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        case .cancelled:
            return
        default:
            return
        }
    }
}
