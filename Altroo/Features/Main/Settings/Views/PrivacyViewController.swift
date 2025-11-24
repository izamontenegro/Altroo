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
            labelText: "policy_privacy".localized,
            labelFont: .sfPro,
            labelType: .title2,
            labelColor: .black10,
            labelWeight: .semibold
        )
        label.numberOfLines = 0
        return label
    }()
    private let subtitleLabel: StandardLabel = {
        let label = StandardLabel(
            labelText: "policy_date".localized,
            labelFont: .sfPro,
            labelType: .body,
            labelColor: .black30,
            labelWeight: .regular
        )
        label.numberOfLines = 0
        return label
    }()
    private let headertext: StandardLabel = {
        let label = StandardLabel(
            labelText: "headertext".localized,
            labelFont: .sfPro,
            labelType: .body,
            labelColor: .black0,
            labelWeight: .regular
        )
        label.numberOfLines = 0
        return label
    }()
    lazy var header: UIStackView = {
        let vstack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, headertext])
        vstack.axis = .vertical
        vstack.distribution = .fill
        vstack.spacing = 4
        vstack.setCustomSpacing(10, after: subtitleLabel)

        vstack.translatesAutoresizingMaskIntoConstraints = false
        return vstack
    }()
    // MARK: - 1. Aceitação da Política
    private let PolicyAcceptanceTitle: StandardLabel = {
        let label = StandardLabel(
            labelText: "PolicyAcceptanceTitle".localized,
            labelFont: .sfPro,
            labelType: .title3,
            labelColor: .blue20,
            labelWeight: .medium
        )
        label.numberOfLines = 0
        return label
    }()
    private let PolicyAcceptanceText: StandardLabel = {
        let label = StandardLabel(
            labelText: "PolicyAcceptanceText".localized,
            labelFont: .sfPro,
            labelType: .body,
            labelColor: .black0,
            labelWeight: .regular
        )
        label.numberOfLines = 0
        return label
    }()
    lazy var PolicyAcceptance: UIStackView = {
        let vstack = UIStackView(arrangedSubviews: [PolicyAcceptanceTitle, PolicyAcceptanceText])
        vstack.axis = .vertical
        vstack.distribution = .fill
        vstack.spacing = 8
        
        vstack.translatesAutoresizingMaskIntoConstraints = false
        return vstack
    }()
    // MARK: - 2. Informações que Coletamos
    private let InformationWeCollectTitle: StandardLabel = {
        let label = StandardLabel(
            labelText: "InformationWeCollectTitle".localized,
            labelFont: .sfPro,
            labelType: .title3,
            labelColor: .blue20,
            labelWeight: .medium
        )
        label.numberOfLines = 0
        return label
    }()
    private let InformationWeCollectText: StandardLabel = {
        let label = StandardLabel(
            labelText: "InformationWeCollectText".localized,
            labelFont: .sfPro,
            labelType: .body,
            labelColor: .black0,
            labelWeight: .regular
        )
        label.numberOfLines = 0
        return label
    }()
    lazy var InformationWeCollect: UIStackView = {
        let vstack = UIStackView(arrangedSubviews: [InformationWeCollectTitle, InformationWeCollectText])
        vstack.axis = .vertical
        vstack.distribution = .fill
        vstack.spacing = 8
        
        vstack.translatesAutoresizingMaskIntoConstraints = false
        return vstack
    }()
    // MARK: - 3. Como Utilizamos as Informações
    private let HowWeUsetheInformationTitle: StandardLabel = {
        let label = StandardLabel(
            labelText: "HowWeUsetheInformationTitle".localized,
            labelFont: .sfPro,
            labelType: .title3,
            labelColor: .blue20,
            labelWeight: .medium
        )
        label.numberOfLines = 0
        return label
    }()
    private let HowWeUsetheInformationText: StandardLabel = {
        let label = StandardLabel(
            labelText: "HowWeUsetheInformationText".localized,
            labelFont: .sfPro,
            labelType: .body,
            labelColor: .black0,
            labelWeight: .regular
        )
        label.numberOfLines = 0
        return label
    }()
    lazy var HowWeUsetheInformation: UIStackView = {
        let vstack = UIStackView(arrangedSubviews: [HowWeUsetheInformationTitle, HowWeUsetheInformationText])
        vstack.axis = .vertical
        vstack.distribution = .fill
        vstack.spacing = 8
        
        vstack.translatesAutoresizingMaskIntoConstraints = false
        return vstack
    }()
    // MARK: - 4. Armazenamento e Segurança dos Dados
    private let DataStorageSecurityTitle: StandardLabel = {
        let label = StandardLabel(
            labelText: "DataStorageSecurityTitle".localized,
            labelFont: .sfPro,
            labelType: .title3,
            labelColor: .blue20,
            labelWeight: .medium
        )
        label.numberOfLines = 0
        return label
    }()
    private let DataStorageSecurityText: StandardLabel = {
        let label = StandardLabel(
            labelText: "DataStorageSecurityText".localized,
            labelFont: .sfPro,
            labelType: .body,
            labelColor: .black0,
            labelWeight: .regular
        )
        label.numberOfLines = 0
        return label
    }()
    lazy var DataStorageSecurity: UIStackView = {
        let vstack = UIStackView(arrangedSubviews: [DataStorageSecurityTitle, DataStorageSecurityText])
        vstack.axis = .vertical
        vstack.distribution = .fill
        vstack.spacing = 8
        
        vstack.translatesAutoresizingMaskIntoConstraints = false
        return vstack
    }()
    // MARK: - 5. Compartilhamento de Informações
    private let InformationSharingTitle: StandardLabel = {
        let label = StandardLabel(
            labelText: "InformationSharingTitle".localized,
            labelFont: .sfPro,
            labelType: .title3,
            labelColor: .blue20,
            labelWeight: .medium
        )
        label.numberOfLines = 0
        return label
    }()
    private let InformationSharingText: StandardLabel = {
        let label = StandardLabel(
            labelText: "InformationSharingText".localized,
            labelFont: .sfPro,
            labelType: .body,
            labelColor: .black0,
            labelWeight: .regular
        )
        label.numberOfLines = 0
        return label
    }()
    lazy var InformationSharing: UIStackView = {
        let vstack = UIStackView(arrangedSubviews: [InformationSharingTitle, InformationSharingText])
        vstack.axis = .vertical
        vstack.distribution = .fill
        vstack.spacing = 8
        
        vstack.translatesAutoresizingMaskIntoConstraints = false
        return vstack
    }()
    // MARK: - 6. Direitos dos Usuários
    private let UserRightsTitle: StandardLabel = {
        let label = StandardLabel(
            labelText: "UserRightsTitle".localized,
            labelFont: .sfPro,
            labelType: .title3,
            labelColor: .blue20,
            labelWeight: .medium
        )
        label.numberOfLines = 0
        return label
    }()
    private let UserRightsText: StandardLabel = {
        let label = StandardLabel(
            labelText: "UserRightsText".localized,
            labelFont: .sfPro,
            labelType: .body,
            labelColor: .black0,
            labelWeight: .regular
        )
        label.numberOfLines = 0
        return label
    }()
    lazy var UserRights: UIStackView = {
        let vstack = UIStackView(arrangedSubviews: [UserRightsTitle, UserRightsText])
        vstack.axis = .vertical
        vstack.distribution = .fill
        vstack.spacing = 8
        
        vstack.translatesAutoresizingMaskIntoConstraints = false
        return vstack
    }()
    // MARK: - 7. Retenção de Dados
    private let DataRetentionTitle: StandardLabel = {
        let label = StandardLabel(
            labelText: "DataRetentionTitle".localized,
            labelFont: .sfPro,
            labelType: .title3,
            labelColor: .blue20,
            labelWeight: .medium
        )
        label.numberOfLines = 0
        return label
    }()
    private let DataRetentionText: StandardLabel = {
        let label = StandardLabel(
            labelText: "DataRetentionText".localized,
            labelFont: .sfPro,
            labelType: .body,
            labelColor: .black0,
            labelWeight: .regular
        )
        label.numberOfLines = 0
        return label
    }()
    lazy var DataRetention: UIStackView = {
        let vstack = UIStackView(arrangedSubviews: [DataRetentionTitle, DataRetentionText])
        vstack.axis = .vertical
        vstack.distribution = .fill
        vstack.spacing = 8
        
        vstack.translatesAutoresizingMaskIntoConstraints = false
        return vstack
    }()
    // MARK: - 8. Alterações nesta Política
    private let ChangesPolicyTitle: StandardLabel = {
        let label = StandardLabel(
            labelText: "ChangesPolicyTitle".localized,
            labelFont: .sfPro,
            labelType: .title3,
            labelColor: .blue20,
            labelWeight: .medium
        )
        label.numberOfLines = 0
        return label
    }()
    private let ChangesPolicyText: StandardLabel = {
        let label = StandardLabel(
            labelText: "ChangesPolicyText".localized,
            labelFont: .sfPro,
            labelType: .body,
            labelColor: .black0,
            labelWeight: .regular
        )
        label.numberOfLines = 0
        return label
    }()
    lazy var ChangesPolicy: UIStackView = {
        let vstack = UIStackView(arrangedSubviews: [ChangesPolicyTitle, ChangesPolicyText])
        vstack.axis = .vertical
        vstack.distribution = .fill
        vstack.spacing = 8
        
        vstack.translatesAutoresizingMaskIntoConstraints = false
        return vstack
    }()
    // MARK: - 9. Contato
    private let ContactTitle: StandardLabel = {
        let label = StandardLabel(
            labelText: "ContactTitle".localized,
            labelFont: .sfPro,
            labelType: .title3,
            labelColor: .blue20,
            labelWeight: .medium
        )
        label.numberOfLines = 0
        return label
    }()
    private let ContactText: StandardLabel = {
        let label = StandardLabel(
            labelText: "ContactText".localized,
            labelFont: .sfPro,
            labelType: .body,
            labelColor: .black0,
            labelWeight: .regular
        )
        label.numberOfLines = 0
        return label
    }()
    lazy var Contact: UIStackView = {
        let vstack = UIStackView(arrangedSubviews: [ContactTitle, ContactText])
        vstack.axis = .vertical
        vstack.distribution = .fill
        vstack.spacing = 8
        
        vstack.translatesAutoresizingMaskIntoConstraints = false
        return vstack
    }()
    
    lazy var vstack: UIStackView = {
        let vstack = UIStackView(arrangedSubviews: [header, PolicyAcceptance, InformationWeCollect, HowWeUsetheInformation, DataStorageSecurity, InformationSharing, UserRights, DataRetention, ChangesPolicy, Contact])
        vstack.axis = .vertical
        vstack.distribution = .fill
        vstack.spacing = 24
        
        vstack.translatesAutoresizingMaskIntoConstraints = false
        return vstack
    }()
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.alwaysBounceVertical = true
        scroll.showsVerticalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        
        return scroll
    }()

    private func setupUI() {
        scrollView.addSubview(vstack)
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            vstack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            vstack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            vstack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            vstack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            vstack.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
}

#Preview {
    PrivacyViewController()
}
