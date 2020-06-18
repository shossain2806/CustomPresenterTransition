//
//  PresentationController.swift
//  ReproduceModalPresentationAutomatic
//
//  Created by Md. Saber Hossain on 18/6/20.
//  Copyright © 2020 Md. Saber Hossain. All rights reserved.
//

import UIKit

class PresentationController: UIPresentationController {
    
    let backgroundView = UIView ()
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        configureBackgroundView()
    }
    
    private func configureBackgroundView() {
        backgroundView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        backgroundView.alpha = 0.0
    }
    
    private func configurePresentedView() {
        guard let presentedView = self.presentedView, let containerView = self.containerView else { return }
      
        presentedView.layer.cornerRadius = 10
        // apply
        presentedView.translatesAutoresizingMaskIntoConstraints = false
    
        let constraints : [NSLayoutConstraint] = [
            presentedView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            presentedView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            presentedView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            presentedView.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor, constant: 20)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    
    override var adaptivePresentationStyle: UIModalPresentationStyle {
        return .overFullScreen
    }
    
    override var shouldPresentInFullscreen: Bool {
        return true
    }
    
    override func containerViewWillLayoutSubviews() {
        guard let containerView = self.containerView else { return }
        configurePresentedView()
        backgroundView.frame = containerView.bounds
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = self.containerView else { return }
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
    
    override func dismissalTransitionWillBegin() {
      
        if let coordinator = self.presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { context in
                self.backgroundView.alpha = 0.0
                self.presentingViewController.view.transform = .identity
                self.presentingViewController.view.layer.cornerRadius = 0.0
            }, completion: nil)
        } else{
            self.presentingViewController.view.transform = .identity
            self.presentingViewController.view.layer.cornerRadius = 0.0
        }
    }
}
