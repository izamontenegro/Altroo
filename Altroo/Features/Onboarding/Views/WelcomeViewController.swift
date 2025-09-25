//
//  WelcomeViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

import UIKit

protocol WelcomeViewControllerDelegate: AnyObject {
    func goToPatientForms()
   
    func goToComorbiditiesForms()
}

class WelcomeViewController: UIViewController {
    weak var delegate: WelcomeViewControllerDelegate?

    let viewLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to our app!"
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nextStepButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Next Step", for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBlue
        
        view.addSubview(viewLabel)
        view.addSubview(nextStepButton)
        
        NSLayoutConstraint.activate([
            viewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            nextStepButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextStepButton.topAnchor.constraint(equalTo: viewLabel.bottomAnchor, constant: 32)
        ])
        
        nextStepButton.addTarget(self, action: #selector(didTapNextStepButton), for: .touchUpInside)
    }
    
    @objc
    func didTapNextStepButton() {
        delegate?.goToPatientForms()
    }
}
