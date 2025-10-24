//
//  SettingsViewController.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 25/09/25.
//

import UIKit

protocol SettingsViewControllerDelegate: AnyObject {
    func goToDevelopers()
}

class SettingsViewController: GradientNavBarViewController {
    
    weak var delegate: SettingsViewControllerDelegate?
    
    override func viewDidLoad() {
        showBackButton = false
        super.viewDidLoad()
        view.backgroundColor = .blue80
        
        setupLayout()
        
        devsbutton.addTarget(self, action: #selector(didTapDevelopersButton), for: .touchUpInside)
    }
    
    // MARK: - Subviews
    private let titleLabel: StandardLabel = {
        let label = StandardLabel(
            labelText: "Ajustes",
            labelFont: .sfPro,
            labelType: .title2,
            labelColor: .black10,
            labelWeight: .semibold
        )
        return label
    }()
    private let subtitleLabel: StandardLabel = {
        let label = StandardLabel(
            labelText: "Gerencie suas preferências e configurações aqui.",
            labelFont: .sfPro,
            labelType: .headline,
            labelColor: .black30,
            labelWeight: .regular
        )
        label.numberOfLines = 0
        return label
    }()
    
    private let emergencybutton: ArrowWideRectangleButton = {
        let emergencybutton = ArrowWideRectangleButton(title: "Adicionar Modo Emergência")
        return emergencybutton
    }()
    private let privacybutton: ArrowWideRectangleButton = {
        let privacybutton = ArrowWideRectangleButton(title: "Privacidade e Segurança")
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
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [emergencybutton, privacybutton, ratingbutton, devsbutton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            stackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -24)
        ])
    }
    
    // MARK: - BUTTON ACTION
    @objc func didTapDevelopersButton() { delegate?.goToDevelopers() }
}

//#Preview {
//    SettingsViewController()
//}
