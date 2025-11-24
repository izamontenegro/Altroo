//
//  SettingsViewController.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 25/09/25.
//

import UIKit

protocol SettingsViewControllerDelegate: AnyObject {
    func goToMyProfile()
    func goToPrivacy()
    func goToPolicy()
    func goToDevelopers()
}

class SettingsViewController: GradientHeader {
    
    weak var delegate: SettingsViewControllerDelegate?
    
    override func viewDidLoad() {
        setNavbarItems(title: "settings".localized,
                       subtitle: "Personalize sua experiência, mantenha seus dados protegidos e conheça o time que dá vida ao app.")
        super.viewDidLoad()
        view.backgroundColor = .blue80
        
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showTabBar(true)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Layout
    private func setupLayout() {
        let myprofilebutton = IconTitleArrowButton()
        myprofilebutton.icon = UIImage(systemName: "person.fill")
        myprofilebutton.titleText = "Meu Perfil"
        myprofilebutton.translatesAutoresizingMaskIntoConstraints = false
        
        let privacybutton = IconTitleArrowButton()
        privacybutton.icon = UIImage(systemName: "lock.fill")
        privacybutton.titleText = "Privacidade e Proteção"
        privacybutton.translatesAutoresizingMaskIntoConstraints = false
        
        let policybutton = IconTitleArrowButton()
        policybutton.icon = UIImage(systemName: "document.fill")
        policybutton.titleText = "Aviso Legal"
        policybutton.translatesAutoresizingMaskIntoConstraints = false
        
        let ratingbutton = IconTitleArrowButton()
        ratingbutton.icon = UIImage(systemName: "star.fill")
        ratingbutton.titleText = "Deixar Avaliação"
        ratingbutton.translatesAutoresizingMaskIntoConstraints = false
        
        let devsbutton = IconTitleArrowButton()
        devsbutton.icon = UIImage(systemName: "hammer.fill")
        devsbutton.titleText = "Desenvolvedoras"
        devsbutton.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [myprofilebutton, privacybutton, policybutton, ratingbutton, devsbutton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -24)
        ])
        
        myprofilebutton.addTarget(self, action: #selector(didTapMyProfileButton), for: .touchUpInside)
        privacybutton.addTarget(self, action: #selector(didTapPrivacyButton), for: .touchUpInside)
        policybutton.addTarget(self, action: #selector(didTapPolicyButton), for: .touchUpInside)
        devsbutton.addTarget(self, action: #selector(didTapDevelopersButton), for: .touchUpInside)
    }
    
    // MARK: - BUTTON ACTION
    @objc func didTapMyProfileButton() { delegate?.goToMyProfile() }
    @objc func didTapPrivacyButton() { delegate?.goToPrivacy() }
    @objc func didTapPolicyButton() { delegate?.goToPolicy() }
    @objc func didTapDevelopersButton() { delegate?.goToDevelopers() }
}

#Preview {
    SettingsViewController()
}
