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
                       subtitle: "settings_nav_description".localized)
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
        let myprofilebutton = IconTitleArrowButton(icon: "person.fill",
                                                   title: "my_profile".localized)
        myprofilebutton.translatesAutoresizingMaskIntoConstraints = false

        let privacybutton = IconTitleArrowButton(icon: "lock.fill",
                                                 title: "privacy".localized)
        privacybutton.translatesAutoresizingMaskIntoConstraints = false
        
        let policybutton = IconTitleArrowButton(icon: "document.fill",
                                                title: "legal".localized)
        policybutton.translatesAutoresizingMaskIntoConstraints = false
        
        let ratingbutton = IconTitleArrowButton(icon: "star.fill",
                                                title: "rating".localized)
        ratingbutton.translatesAutoresizingMaskIntoConstraints = false
        
        let devsbutton = IconTitleArrowButton(icon: "hammer.fill",
                                              title: "devs".localized)
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

//#Preview {
//    SettingsViewController()
//}
