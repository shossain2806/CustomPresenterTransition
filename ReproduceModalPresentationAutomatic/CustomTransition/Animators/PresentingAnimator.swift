//
//  PresentingAnimator.swift
//  ReproduceModalPresentationAutomatic
//
//  Created by Md. Saber Hossain on 18/6/20.
//  Copyright © 2020 Md. Saber Hossain. All rights reserved.
//

import UIKit

class PresentingAnimator: NSObject, UIViewControllerAnimatedTransitioning {
 
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return totalTransitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let toViewController = transitionContext.viewController(forKey: .to)!
        let toView = transitionContext.view(forKey: .to)!
        let containerView = transitionContext.containerView
        containerView.addSubview(toView)
        toView.frame = transitionContext.finalFrame(for: toViewController)
        toView.transform = CGAffineTransform(translationX: 0, y: toView.frame.size.height)
        let animator = UIViewPropertyAnimator(
        duration: transitionDuration(using: transitionContext),
        curve: .easeOut) {
            toView.transform = .identity
        }
        
        animator.addCompletion { position in
            transitionContext.completeTransition(position == .end)
        }
        
        animator.startAnimation()
        
    }
}
