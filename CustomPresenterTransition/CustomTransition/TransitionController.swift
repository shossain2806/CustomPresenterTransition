//
//  TransitionController.swift
//  CustomPresenterTransition
//
//  Created by Md. Saber Hossain on 18/6/20.
//  Copyright © 2020 Md. Saber Hossain. All rights reserved.
//

import UIKit

let totalTransitionDuration = 0.3

class TransitionController: NSObject, UIViewControllerTransitioningDelegate {
    
    var transitionDriver: DismissingTransitionDriver?
    var initiallyInteractive = false
    weak var presentationController : PresentationController?
    
    lazy var panGesture: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer()
        pan.maximumNumberOfTouches = 1
        pan.delegate = self
        pan.addTarget(self, action: #selector(initiateInteractively))
        return pan
    }()
    
    
    @objc func initiateInteractively(_ panGesture: UIPanGestureRecognizer) {
        if panGesture.state == .began && transitionDriver == nil {
            initiallyInteractive = true
           
        }
    }
    
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController) -> UIPresentationController? {
        let controller = PresentationController(presentedViewController: presented,
                                                presenting: presenting,
                                                gesture: panGesture)
        presentationController = controller
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

extension TransitionController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let dismissingAnimator = self.transitionDriver else {
            let translation = panGesture.translation(in: panGesture.view)
            let translationIsVertical = (translation.y > 0) && (abs(translation.y) > abs(translation.x))
            return translationIsVertical
        }
               
        return dismissingAnimator.isInteractive
    }
}


// Manage interactive dismiss animation
extension TransitionController: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return totalTransitionDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {}
    
    func animationEnded(_ transitionCompleted: Bool) {
        transitionDriver = nil
        initiallyInteractive = false
    }
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        return (transitionDriver?.transitionAnimator)!
    }
}


extension TransitionController: UIViewControllerInteractiveTransitioning {
    
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
       
        let alongsideAnimation = presentationController?.dimissAnimation
        transitionDriver = DismissingTransitionDriver(context: transitionContext,
                                                gesture: panGesture,
                                                alongsideAnimation: alongsideAnimation)
        
    }
    
    var wantsInteractiveStart: Bool {
        return initiallyInteractive
    }
}
