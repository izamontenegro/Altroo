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
        
        myprofilebutton.addTarget(self, action: #selector(didTapMyProfileButton), for: .touchUpInside)
        privacybutton.addTarget(self, action: #selector(didTapPrivacyButton), for: .touchUpInside)
        policybutton.addTarget(self, action: #selector(didTapPolicyButton), for: .touchUpInside)
        devsbutton.addTarget(self, action: #selector(didTapDevelopersButton), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showTabBar(true)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Subviews
    
    private let myprofilebutton: ArrowWideRectangleButton = {
        let emergencybutton = ArrowWideRectangleButton(title: "Meu Perfil")
        return emergencybutton
    }()
    private let privacybutton: ArrowWideRectangleButton = {
        let privacybutton = ArrowWideRectangleButton(title: "Privacidade e Proteção")
        return privacybutton
    }()
    private let policybutton: ArrowWideRectangleButton = {
        let privacybutton = ArrowWideRectangleButton(title: "Aviso Legal")
        return privacybutton
    }()
    private let ratingbutton: ArrowWideRectangleButton = {
        let ratingbutton = ArrowWideRectangleButton(title: "Deixar Avaliação")
        return ratingbutton
    }()
    private let devsbutton: ArrowWideRectangleButton = {
        let devsbutton = ArrowWideRectangleButton(title: "Desenvolvedoras")
        return devsbutton
    }()
    
    // MARK: - Layout
    private func setupLayout() {

        
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
