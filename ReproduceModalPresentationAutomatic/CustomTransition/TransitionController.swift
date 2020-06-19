//
//  TransitionController.swift
//  ReproduceModalPresentationAutomatic
//
//  Created by Md. Saber Hossain on 18/6/20.
//  Copyright © 2020 Md. Saber Hossain. All rights reserved.
//

import UIKit

let totalTransitionDuration = 0.3

class TransitionController: NSObject, UIViewControllerTransitioningDelegate {
    
    var dismissingAnimator: DismissingAnimator?
    var initiallyInteractive = false
    var presentationController : PresentationController?
    
    lazy var panGesture: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer()
        pan.maximumNumberOfTouches = 1
        pan.addTarget(self, action: #selector(initiateInteractively))
        return pan
    }()
    
    
    @objc func initiateInteractively(_ panGesture: UIPanGestureRecognizer) {
        if panGesture.state == .began && dismissingAnimator == nil {
            initiallyInteractive = true
           
        }else {
            initiallyInteractive = false
        }
    }
    
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController) -> UIPresentationController? {
        presentationController = PresentationController(presentedViewController: presented,
                                                presenting: presenting,
                                                gesture: panGesture)
        return presentationController
    }
    
    
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentingAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self
    }
    
    
}

// Manage interactive dismiss animation
extension TransitionController: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return totalTransitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {}
    
    func animationEnded(_ transitionCompleted: Bool) {
        dismissingAnimator = nil
        initiallyInteractive = false
    }
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        return (dismissingAnimator?.transitionAnimator)!
    }
}


extension TransitionController: UIViewControllerInteractiveTransitioning {
    
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
       
        let alongsideAnimation = presentationController?.dimissAnimation
        dismissingAnimator = DismissingAnimator(context: transitionContext,
                                                gesture: panGesture,
                                                alongsideAnimation: alongsideAnimation)
        
    }
    
    var wantsInteractiveStart: Bool {
        return initiallyInteractive
    }
}
