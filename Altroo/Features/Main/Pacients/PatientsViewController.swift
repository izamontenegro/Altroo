//
//  PatientsViewControllerr.swift
//  Altroo
//
//  Created by Marcelle Ribeiro Queiroz on 30/10/25.
//

import UIKit

class PatientsViewController: GradientNavBarViewController {

    let viewLabel: UILabel = {
        let label = UILabel()
        label.text = "Assistidos"
        label.tintColor = .black10
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override func viewDidLoad() {
        showBackButton = false
        super.viewDidLoad()

        view.backgroundColor = .blue80
        
        view.addSubview(viewLabel)
        
        NSLayoutConstraint.activate([
            viewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
