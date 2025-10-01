//
//  ComorbitiesFormsViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

import UIKit

class ComorbiditiesFormsViewController: UIViewController {
    
    weak var delegate: AssociatePatientViewControllerDelegate?
    
    let viewLabel: UILabel = {
        let label = UILabel()
        label.text = "Insert the comorbidities here"
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let doneButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Next Step", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 8
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemOrange
        
        view.addSubview(viewLabel)
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            viewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doneButton.topAnchor.constraint(equalTo: viewLabel.bottomAnchor, constant: 32)
        ])
        
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
    }
    
    @objc
    func didTapDoneButton() {
        delegate?.goToShiftForms()
    }
}
