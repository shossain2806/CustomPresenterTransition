//
//  SecondaryViewController.swift
//  CustomPresenterTransition
//
//  Created by Md. Saber Hossain on 18/6/20.
//  Copyright © 2020 Md. Saber Hossain. All rights reserved.
//

import UIKit

class SecondaryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let rightButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(btnDismissPressed))
        self.navigationItem.rightBarButtonItem = rightButton
        configureTableView()
    }
    
    private func configureTableView() {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        let constraints : [NSLayoutConstraint] = [
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
    }
    
    @objc func btnDismissPressed() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension SecondaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
    
}
