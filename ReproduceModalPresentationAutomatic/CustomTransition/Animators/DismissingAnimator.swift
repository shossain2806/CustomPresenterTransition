//
//  DismissingAnimator.swift
//  ReproduceModalPresentationAutomatic
//
//  Created by Md. Saber Hossain on 18/6/20.
//  Copyright © 2020 Md. Saber Hossain. All rights reserved.
//

import UIKit

class DismissingAnimator: NSObject {
    
    var transitionAnimator: UIViewPropertyAnimator!
    var isInteractive: Bool { return transitionContext.isInteractive }
    let transitionContext: UIViewControllerContextTransitioning
    let translationYMax : CGFloat

    private let panGestureRecognizer: UIPanGestureRecognizer
    
    init(context: UIViewControllerContextTransitioning, gesture: UIPanGestureRecognizer, alongsideAnimation: (() -> Void)?) {
        self.transitionContext = context
        self.panGestureRecognizer = gesture
        let fromViewController = context.viewController(forKey: .from)!
        let fromView = fromViewController.view!
        translationYMax = fromView.frame.size.height
        
        super.init()
        self.panGestureRecognizer.addTarget(self, action: #selector(updateInteraction(_:)))
        
        transitionAnimator = UIViewPropertyAnimator(duration: totalTransitionDuration,
                                                    curve: .easeOut,
                                                    animations:{
            fromView.transform = CGAffineTransform(translationX: 0,
                                                   y: fromView.frame.size.height)
        })
        
        if let animation = alongsideAnimation {
            transitionAnimator.addAnimations(animation)
        }
      
        transitionAnimator.addCompletion { [unowned self] (position) in
            
            let completed = (position == .end)
            self.transitionContext.completeTransition(completed)
        }
        
       
        if context.isInteractive == false {
            animate(.end)
        }
    }
    
    @objc func updateInteraction(_ fromGesture: UIPanGestureRecognizer) {
        switch fromGesture.state {
        case .began, .changed:

            let translation = fromGesture.translation(in: fromGesture.view)
            let percentComplete = transitionAnimator.fractionComplete + progressStepFor(translation: translation)
            
            transitionAnimator.fractionComplete = percentComplete
            transitionContext.updateInteractiveTransition(percentComplete)
            
            fromGesture.setTranslation(CGPoint.zero, in: fromGesture.view)
        case .ended, .cancelled:
            endInteraction()
        default: break
        }
    }
    
    private func progressStepFor(translation: CGPoint) -> CGFloat {
        return  translation.y / translationYMax
    }
    
    private func completionPosition() -> UIViewAnimatingPosition {
        let completionThreshold: CGFloat = 0.33
        let velocity = panGestureRecognizer.velocity(in: panGestureRecognizer.view).y
        if transitionAnimator.fractionComplete > completionThreshold || velocity > 1200 {
            return .end
        } else {
            return .start
        }
    }
    
    func endInteraction() {
        // Ensure the context is currently interactive
        guard transitionContext.isInteractive else { return }
        // Inform the transition context of whether we are finishing or cancelling the transition
        let completionPosition = self.completionPosition()
        if completionPosition == .end {
            transitionContext.finishInteractiveTransition()
        } else {
            transitionContext.cancelInteractiveTransition()
        }
        // Begin the animation phase of the transition to either the start or finsh position
        animate(completionPosition)
    }
    
    func animate(_ toPosition: UIViewAnimatingPosition) {
        transitionAnimator.isReversed = (toPosition == .start)
        
        // Start or continue the transition animator (if it was previously paused)
        if transitionAnimator.state == .inactive {
            transitionAnimator.startAnimation()
        } else {
            let durationFactor = CGFloat(totalTransitionDuration / transitionAnimator.duration)
            transitionAnimator.continueAnimation(withTimingParameters: nil, durationFactor: durationFactor)
        }
    }
    
    
}
