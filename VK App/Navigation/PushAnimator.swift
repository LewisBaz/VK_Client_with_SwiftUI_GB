//
//  PushAnimator.swift
//  VK App
//
//  Created by Lev Bazhkov on 24.05.2021.
//

import UIKit

final class PushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration = 0.5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let sourceVC = transitionContext.viewController(forKey: .from) else { return }
        guard let destinationVC = transitionContext.viewController(forKey: .to) else { return }
        
        transitionContext.containerView.addSubview(destinationVC.view)
        destinationVC.view.frame = sourceVC.view.frame
        destinationVC.view.transform = CGAffineTransform(translationX: sourceVC.view.frame.width, y: 0)
        
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: [ .calculationModePaced ],
            animations: {
                let translationSourceVC = CGAffineTransform(translationX: -sourceVC.view.frame.width, y: 0)
                let scaleSourceVC = CGAffineTransform(scaleX: 0.7, y: 0.7)
                let transformSourceVC = scaleSourceVC.concatenating(translationSourceVC)
                
                let translationDestinationVC = CGAffineTransform(translationX: sourceVC.view.frame.width, y: 0)
                let scaleDestinationVC = CGAffineTransform(scaleX: 1.2, y: 1.2)
                let transformDestinationVC = scaleDestinationVC.concatenating(translationDestinationVC)

                UIView.addKeyframe(
                    withRelativeStartTime: 0,
                    relativeDuration: 0.5,
                    animations: {
                        sourceVC.view.transform = transformSourceVC
                    })
                UIView.addKeyframe(
                    withRelativeStartTime: 0.5,
                    relativeDuration: 0.5,
                    animations: {
                        destinationVC.view.transform = transformDestinationVC
                    })
                UIView.addKeyframe(
                    withRelativeStartTime: 0.8,
                    relativeDuration: 0.5,
                    animations: {
                        destinationVC.view.transform = .identity
                    })
            },
            completion: { finished in
                if finished && !transitionContext.transitionWasCancelled {
                    sourceVC.view.transform = .identity
                }
                transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
            })
    }
}
