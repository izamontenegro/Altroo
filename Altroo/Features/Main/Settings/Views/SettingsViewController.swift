//
//  SettingsViewController.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 25/09/25.
//

import UIKit

protocol SettingsViewControllerDelegate: AnyObject {
    func goToUserProfile()
    func goToPrivacySecurity()
    func goToDevelopers()

}

class SettingsViewController: UIViewController {
    weak var delegate: SettingsViewControllerDelegate?
    
    let viewLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings View"
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let vStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemTeal
        
        view.addSubview(viewLabel)
        view.addSubview(vStack)
        
        addDelegateButtons()
        
        NSLayoutConstraint.activate([
            viewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            vStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vStack.topAnchor.constraint(equalTo: viewLabel.bottomAnchor),
        ])
    }
    
    private func addDelegateButtons() {
        createButton(title: "User Profile", action: #selector(didTapUserProfileButton))
        createButton(title: "Privacy and Security", action: #selector(didTapPrivacySecurityButton))
        createButton(title: "Ratings", action: #selector(didTapDevelopersButton))
        createButton(title: "Developers", action: #selector(didTapDevelopersButton))
    }
    
    @objc func didTapUserProfileButton() {
        delegate?.goToUserProfile()
    }
    
    @objc func didTapPrivacySecurityButton() {
        delegate?.goToPrivacySecurity()
    }
    
    @objc func didTapDevelopersButton() {
        delegate?.goToDevelopers()
    }
    
    //UTILITY FUNC
    private func createButton(title: String, action: Selector) {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        vStack.addArrangedSubview(button)
    }
}
