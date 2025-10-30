//
//  PrivacySecurityViewController.swift
//  Altroo
//
//  Created by Raissa Parente on 02/10/25.
//

import UIKit

class PrivacyViewController: GradientNavBarViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .pureWhite
        
        setupUI()
    }
    
    private let titleLabel: StandardLabel = {
        let label = StandardLabel(
            labelText: "Política de Privacidade e Proteção",
            labelFont: .sfPro,
            labelType: .title2,
            labelColor: .black10,
            labelWeight: .semibold
        )
        return label
    }()
    private let subtitleLabel: StandardLabel = {
        let label = StandardLabel(
            labelText: "Atualizada em: 29 de Outubro de 2025",
            labelFont: .sfPro,
            labelType: .body,
            labelColor: .black30,
            labelWeight: .regular
        )
        label.numberOfLines = 0
        return label
    }()
    
    private let privacyTitle: StandardLabel = {
        let label = StandardLabel(
            labelText: "Aceitação da Política",
            labelFont: .sfPro,
            labelType: .title3,
            labelColor: .blue20,
            labelWeight: .medium
        )
        
        return label
    }()
    private let privacyText: StandardLabel = {
        let label = StandardLabel(
            labelText: "Ao utilizar o Altroo, você declara estar ciente e de acordo com os termos desta Política de Privacidade. \n\nSe não concordar com algum dos termos, recomendamos interromper o uso do aplicativo e solicitar a exclusão de sua conta.",
            labelFont: .sfPro,
            labelType: .body,
            labelColor: .black0,
            labelWeight: .regular
        )
        
        label.numberOfLines = 0
        return label
    }()
    
    private let dataTitle: StandardLabel = {
        let label = StandardLabel(
            labelText: "Coleta de Dados",
            labelFont: .sfPro,
            labelType: .title3,
            labelColor: .blue20,
            labelWeight: .medium
        )
        
        return label
    }()
    private let dataText: StandardLabel = {
        let label = StandardLabel(
            labelText: "O Altroo coleta apenas as informações necessárias para o funcionamento do aplicativo e para proporcionar uma melhor experiência de cuidado. \nEssas informações podem incluir: \n• Dados de cadastro, como nome, e-mail e telefones; \n• Informações sobre o assistido, como nome, idade e dados relevantes para o cuidado; \n• Registros de atividades e anotações inseridas manualmente pelo cuidador; \n• Informações sobre o uso do aplicativo, como frequência de acesso e funcionalidades utilizadas. \n\nO Altroo não coleta dados sensíveis de saúde automaticamente, apenas aqueles que o usuário decide registrar de forma voluntária.",
            labelFont: .sfPro,
            labelType: .body,
            labelColor: .black0,
            labelWeight: .regular
        )
        
        label.numberOfLines = 0
        return label
    }()
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(privacyTitle)
        view.addSubview(privacyText)
        view.addSubview(dataTitle)
        view.addSubview(dataText)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        privacyTitle.translatesAutoresizingMaskIntoConstraints = false
        privacyText.translatesAutoresizingMaskIntoConstraints = false
        dataTitle.translatesAutoresizingMaskIntoConstraints = false
        dataText.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Header
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            // policy acceptance
            privacyTitle.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24),
            privacyTitle.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            privacyTitle.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            privacyText.topAnchor.constraint(equalTo: privacyTitle.bottomAnchor, constant: 8),
            privacyText.leadingAnchor.constraint(equalTo: privacyTitle.leadingAnchor),
            privacyText.trailingAnchor.constraint(equalTo: privacyTitle.trailingAnchor),
            
            // data collection
            dataTitle.topAnchor.constraint(equalTo: privacyText.bottomAnchor, constant: 24),
            dataTitle.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dataTitle.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            dataText.topAnchor.constraint(equalTo: dataTitle.bottomAnchor, constant: 8),
            dataText.leadingAnchor.constraint(equalTo: dataTitle.leadingAnchor),
            dataText.trailingAnchor.constraint(equalTo: dataTitle.trailingAnchor)
        ])
    }
}

//#Preview {
//    PrivacyViewController()
//}
