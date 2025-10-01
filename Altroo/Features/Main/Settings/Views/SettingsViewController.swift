//
//  SettingsViewController.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 25/09/25.
//

import UIKit

class SettingsViewController: UIViewController {
    
    let viewLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings View"
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemTeal
        
        view.addSubview(viewLabel)
        
        NSLayoutConstraint.activate([
            viewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
}
