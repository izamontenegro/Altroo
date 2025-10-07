//
//  UserProfileViewController.swift
//  Altroo
//
//  Created by Raissa Parente on 02/10/25.
//

import UIKit

class UserProfileViewController: UIViewController {

    let viewLabel: UILabel = {
        let label = UILabel()
        label.text = "User Profile View"
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGray
        
        view.addSubview(viewLabel)
        
        NSLayoutConstraint.activate([
            viewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
