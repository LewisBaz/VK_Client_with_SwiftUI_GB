//
//  AnimatedNavigationController.swift
//  VK App
//
//  Created by Lev Bazhkov on 24.05.2021.
//

import UIKit

final class AnimatedNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    let interactiveTransition = InteractiveTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    func navigationController(
        _ navigationController: UINavigationController,
        interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {

        return interactiveTransition.hasStarted ? interactiveTransition : nil
    }

    func navigationController(
        _ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .pop:
            self.interactiveTransition.viewController = toVC
            return PopAnimator()
        case .push:
            if navigationController.viewControllers.first != toVC {
                self.interactiveTransition.viewController = toVC
            }
            return PushAnimator()
        default:
            return nil
        }
    }
}

extension AnimatedNavigationController: UIViewControllerTransitioningDelegate {

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PopAnimator()
    }

    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PushAnimator()
    }
}

