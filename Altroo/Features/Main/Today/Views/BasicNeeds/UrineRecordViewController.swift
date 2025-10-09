//
//  UrineRecordViewController.swift
//  Altroo
//
//  Created by Raissa Parente on 02/10/25.
//

import UIKit

class UrineRecordViewController: UIViewController {

    let viewLabel: UILabel = {
        let label = UILabel()
        label.text = "Record Urine View"
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .yellow
        
        view.addSubview(viewLabel)
        
        NSLayoutConstraint.activate([
            viewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
