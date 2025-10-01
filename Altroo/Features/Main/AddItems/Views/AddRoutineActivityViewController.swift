//
//  AddTaskViewController.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 29/09/25.
//

import UIKit

class AddSymptomViewController: UIViewController {

    let viewLabel: UILabel = {
        let label = UILabel()
        label.text = "Add Symptom View"
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemIndigo
        
        view.addSubview(viewLabel)
        
        NSLayoutConstraint.activate([
            viewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
