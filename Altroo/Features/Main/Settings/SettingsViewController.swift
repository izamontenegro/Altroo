//
//  SettingsViewController.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 25/09/25.
//

import UIKit

protocol SettingsViewControllerDelegate: AnyObject {
    func goToPrivacySecurity()
    func goToDevelopers()
}

class SettingsViewController: UIViewController {
    
    weak var delegate: SettingsViewControllerDelegate?
    
    let vStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue80
        
        view.addSubview(vStack)
        
        addDelegateButtons()
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func addDelegateButtons() {
        createStandardButton(title: "Privacidade e Segurança", action: #selector(didTapPrivacySecurityButton))
        createStandardButton(title: "Desenvolvedoras", action: #selector(didTapDevelopersButton))
    }
    
    // MARK: - BUTTON ACTIONS
    @objc func didTapPrivacySecurityButton() { delegate?.goToPrivacySecurity() }
    @objc func didTapDevelopersButton() { delegate?.goToDevelopers() }
    
    // MARK: - Utility
    private func createStandardButton(title: String, action: Selector) {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = .teal20
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 22
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.addTarget(self, action: action, for: .touchUpInside)
        vStack.addArrangedSubview(button)
    }
}

#Preview {
    SettingsViewController()
}
