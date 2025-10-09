//
//  MedicationTimeSheetViewController.swift
//  Altroo
//
//  Created by Raissa Parente on 03/10/25.
//
import UIKit

class MedicationTimeSheetViewController: UIViewController {

    let viewLabel: UILabel = {
        let label = UILabel()
        label.text = "Change Time Medication Was Taken View"
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        view.addSubview(viewLabel)
        
        NSLayoutConstraint.activate([
            viewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
