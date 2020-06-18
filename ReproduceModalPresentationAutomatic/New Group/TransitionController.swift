//
//  TransitionController.swift
//  ReproduceModalPresentationAutomatic
//
//  Created by Md. Saber Hossain on 18/6/20.
//  Copyright © 2020 Md. Saber Hossain. All rights reserved.
//

import UIKit

class TransitionController: NSObject, UIViewControllerTransitioningDelegate {

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let controller = PresentationController(presentedViewController: presented, presenting: presenting)
        return controller
    }
    

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentingAnimator()
    }
    
    
}
