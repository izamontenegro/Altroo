//
//  ProfileViewController.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 29/09/25.
//

import UIKit

protocol ProfileViewControllerDelegate: AnyObject {
    func openChangeCaregiversSheet()
    func openEditCaregiversSheet()
}

class ProfileViewController: UIViewController {
    weak var delegate: ProfileViewControllerDelegate?

    let viewLabel: UILabel = {
        let label = UILabel()
        label.text = "Profile View"
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let changeCareRecipientButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change care recipient profile", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let editCaregiverButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Caregiver", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let exportButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Export file", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let vStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemTeal
        
        view.addSubview(vStack)
        
        vStack.addArrangedSubview(viewLabel)
        vStack.addArrangedSubview(changeCareRecipientButton)
        vStack.addArrangedSubview(editCaregiverButton)
        vStack.addArrangedSubview(exportButton)
        
        changeCareRecipientButton.addTarget(self, action: #selector(didTapChangeCareRecipientButton), for: .touchUpInside)
        editCaregiverButton.addTarget(self, action: #selector(didTapEditCaregiverButton), for: .touchUpInside)

        NSLayoutConstraint.activate([
            vStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vStack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
    }
    
    @objc func didTapChangeCareRecipientButton() {
        delegate?.openChangeCaregiversSheet()
    }
    
    @objc func didTapEditCaregiverButton() {
        delegate?.openEditCaregiversSheet()
    }

}
