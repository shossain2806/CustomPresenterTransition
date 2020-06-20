//
//  TransitionController.swift
//  CustomPresenterTransition
//
//  Created by Md. Saber Hossain on 18/6/20.
//  Copyright © 2020 Md. Saber Hossain. All rights reserved.
//

import UIKit

let totalTransitionDuration = 0.3

protocol InteractiveTransitionController: class {
    var isInteractive : Bool { get set }
    var currentlyTranstionRunning : Bool { get }
    var gesture: UIPanGestureRecognizer { get }
}

class TransitionController: NSObject, UIViewControllerTransitioningDelegate {
    
    var transitionDriver: DismissingTransitionDriver?
    var initiallyInteractive = false
   
    weak var presentationController : PresentationController?
    
    lazy var panGesture: UIPanGestureRecognizer = {
        let pan = UIPanGestureRecognizer()
        pan.maximumNumberOfTouches = 1
        return pan
    }()
    
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController) -> UIPresentationController? {
        let controller = PresentationController(presentedViewController: presented,
                                                presenting: presenting,
                                                transitionController: self)
        presentationController = controller
        return presentationController
    }
  
    // non interactive transition in presenting
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentingAnimator()
    }
    
    
    //interactive transition in dismissing
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self
    }
    
}

//MARK:- Manage interactive dismiss transition

extension TransitionController: InteractiveTransitionController {
   
    var gesture: UIPanGestureRecognizer {
        return panGesture
    }
    
    var isInteractive: Bool {
        get {
            return initiallyInteractive
        }
        set {
            initiallyInteractive = newValue
        }
    }
    
    var currentlyTranstionRunning: Bool {
        return transitionDriver != nil
    }
    
}

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

