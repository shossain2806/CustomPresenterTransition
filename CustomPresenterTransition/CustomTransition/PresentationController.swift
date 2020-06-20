//
//  PresentationController.swift
//  CustomPresenterTransition
//
//  Created by Md. Saber Hossain on 18/6/20.
//  Copyright © 2020 Md. Saber Hossain. All rights reserved.
//

import UIKit

class PresentationController: UIPresentationController {
    
    let backgroundView = UIView ()
    let panGesture : UIPanGestureRecognizer
    weak var controller : InteractiveTransitionController?
    
    init(presentedViewController: UIViewController,
         presenting presentingViewController: UIViewController?,
         transitionController: InteractiveTransitionController
    ) {
        self.controller = transitionController
        self.panGesture = transitionController.gesture
        super.init(presentedViewController: presentedViewController,
                   presenting: presentingViewController)
        configureBackgroundView()
        configureGesture()
        
    }
    
    override var adaptivePresentationStyle: UIModalPresentationStyle {
        return .overFullScreen
    }
    
    override var shouldPresentInFullscreen: Bool {
        return true
    }
    
    override func containerViewWillLayoutSubviews() {
        guard
            let containerView = self.containerView
        else { return }
        configurePresentedView()
        backgroundView.frame = containerView.bounds
    }
    
    override func presentationTransitionWillBegin() {
        guard
            let containerView = self.containerView
        else { return }
        containerView.insertSubview(backgroundView, at: 0)
        
        if let coordinator = self.presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { context in
                self.backgroundView.alpha = 1.0
                self.presentingViewController.view.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)
                self.presentingViewController.view.layer.cornerRadius = 10
            }, completion: nil)
        } else{
            self.backgroundView.alpha = 1.0
            self.presentingViewController.view.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)
            self.presentingViewController.view.layer.cornerRadius = 10
        }
    }
    
    //to make disappearing animation interruptible we cannot use `dismissalTransitionWillBegin`
    var dimissAnimation : () -> Void {
        let animationClosure = { [unowned self] in
            self.backgroundView.alpha = 0.0
            self.presentingViewController.view.transform = .identity
            self.presentingViewController.view.layer.cornerRadius = 0.0
        }
        return animationClosure
    }
    
}

extension PresentationController {
    
    private func configureGesture() {
        presentedView?.addGestureRecognizer(panGesture)
        panGesture.delegate = self
        panGesture.addTarget(self, action: #selector(initiateInteractively(_:)))
        
    }
    
    private func configureBackgroundView() {
        backgroundView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        backgroundView.alpha = 0.0
    }
    
    private func configurePresentedView() {
        guard
            let presentedView = self.presentedView,
            let containerView = self.containerView
        else { return }
        
        presentedView.layer.cornerRadius = 10
        presentedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        presentedView.translatesAutoresizingMaskIntoConstraints = false
        let constraints : [NSLayoutConstraint] = [
            presentedView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            presentedView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            presentedView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            presentedView.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor, constant: 20)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc private func initiateInteractively(_ panGesture: UIPanGestureRecognizer) {
        if panGesture.state == .began && self.controller?.currentlyTranstionRunning == false {
            self.controller?.isInteractive = true
            self.presentingViewController.dismiss(animated: true, completion: nil)
        }
    }
}

extension PresentationController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let controller = self.controller, controller.currentlyTranstionRunning == true else {
            let translation = panGesture.translation(in: panGesture.view)
            let translationIsVertical = (translation.y > 0) && (abs(translation.y) > abs(translation.x))
            return translationIsVertical
        }
               
        return controller.isInteractive
    }
}

