//
//  SecondaryViewController.swift
//  ReproduceModalPresentationAutomatic
//
//  Created by Md. Saber Hossain on 18/6/20.
//  Copyright © 2020 Md. Saber Hossain. All rights reserved.
//

import UIKit

class SecondaryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        // Do any additional setup after loading the view.
        
        let rightButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(btnDismissPressed))
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc func btnDismissPressed() {
        self.dismiss(animated: true, completion: nil)
    }

}
