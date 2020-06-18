//
//  ViewController.swift
//  ReproduceModalPresentationAutomatic
//
//  Created by Md. Saber Hossain on 18/6/20.
//  Copyright © 2020 Md. Saber Hossain. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let transitionDriver = TransitionController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnDefaultShowPressed(_ sender: Any) {
        let showVC = SecondaryViewController()
        self.present(showVC, animated: true, completion: nil)
    }

    @IBAction func btnCustomShowPressed(_ sender: Any) {
        let showVC = SecondaryViewController()
        showVC.transitioningDelegate = transitionDriver
        showVC.modalPresentationStyle = .custom
    
        self.present(showVC, animated: true, completion: nil)
    }
    
}

