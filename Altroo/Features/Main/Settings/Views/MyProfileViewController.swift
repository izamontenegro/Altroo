//
//  MyProfileViewController.swift
//  Altroo
//
//  Created by Marcelle Ribeiro Queiroz on 29/10/25.
//

import UIKit

class MyProfileViewController: GradientNavBarViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .pureWhite
        
        headerUI()
        infoProfileUI()
    }
    
    private let titleLabel: StandardLabel = {
        let label = StandardLabel(
            labelText: "Meu Perfil",
            labelFont: .sfPro,
            labelType: .title2,
            labelColor: .black10,
            labelWeight: .semibold
        )
        return label
    }()
    private let subtitleLabel: StandardLabel = {
        let label = StandardLabel(
            labelText: "Gerencie suas informações aqui.",
            labelFont: .sfPro,
            labelType: .headline,
            labelColor: .black30,
            labelWeight: .regular
        )
        label.numberOfLines = 0
        return label
    }()
    private let editButton: CapsuleWithCircleView = {
        let label = CapsuleWithCircleView(
            text: "Editar",
            textColor: .teal20,
            nameIcon: "pencil",
            nameIconColor: .pureWhite,
            circleIconColor: .teal20
        )
        return label
    }()
    
    // TODO: TRAZER INFORMAÇÕES DO USUÁRIO AQUI
    private let name: InfoRowView = {
        let label = InfoRowView(
            title: "Nome",
            info: "Maria Clara"
        )
        return label
    }()
    private let contact: InfoRowView = {
        let label = InfoRowView(
            title: "Contato",
            info: "85 99999 9999"
        )
        return label
    }()
    
    private func headerUI() {
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(editButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            editButton.topAnchor.constraint(equalTo: titleLabel.topAnchor)
        ])
    }
    
    private func infoProfileUI() {
        view.addSubview(name)
        view.addSubview(contact)
        
        name.translatesAutoresizingMaskIntoConstraints = false
        contact.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 48),
            name.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            contact.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 12),
            contact.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor)
        ])
    }
}

#Preview {
    MyProfileViewController()
}
