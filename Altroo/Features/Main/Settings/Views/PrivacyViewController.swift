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
        label.numberOfLines = 0
        
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
    private let headertext: StandardLabel = {
        let label = StandardLabel(
            labelText: "A sua privacidade é importante para nós. Esta Política de Privacidade descreve como o Altroo coleta, utiliza, armazena e protege as informações pessoais de cuidadores, assistidos e familiares que utilizam o aplicativo. Ao usar o Altroo, você concorda com as práticas descritas a seguir.",
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
            labelText: "Aceitação da Política",
            labelFont: .sfPro,
            labelType: .title3,
            labelColor: .blue20,
            labelWeight: .medium
        )
        
        return label
    }()
    private let PolicyAcceptanceText: StandardLabel = {
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
            labelText: "Informações que Coletamos",
            labelFont: .sfPro,
            labelType: .title3,
            labelColor: .blue20,
            labelWeight: .medium
        )
        
        return label
    }()
    private let InformationWeCollectText: StandardLabel = {
        let label = StandardLabel(
            labelText: "O Altroo coleta apenas as informações necessárias para o funcionamento do aplicativo e para proporcionar uma melhor experiência de cuidado. \n\nEssas informações podem incluir: \n• Dados de cadastro, como nome, e-mail e telefones; \n• Informações sobre o assistido, como nome, idade e dados relevantes para o cuidado; \n• Registros de atividades e anotações inseridas manualmente pelo cuidador; \n• Informações sobre o uso do aplicativo, como frequência de acesso e funcionalidades utilizadas. \n\nO Altroo não coleta dados sensíveis de saúde automaticamente, apenas aqueles que o usuário decide registrar de forma voluntária.",
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
            labelText: "Como Utilizamos as Informações",
            labelFont: .sfPro,
            labelType: .title3,
            labelColor: .blue20,
            labelWeight: .medium
        )
        
        return label
    }()
    private let HowWeUsetheInformationText: StandardLabel = {
        let label = StandardLabel(
            labelText: "As informações são utilizadas para:\n• Permitir o funcionamento do aplicativo e suas principais funcionalidades;\n• Facilitar o compartilhamento de informações de cuidado entre cuidadores e familiares;\n• Personalizar a experiência do usuário e aprimorar o desempenho do app;\n• Enviar comunicações relacionadas ao uso do Altroo, como lembretes ou notificações de atualização. \n\nO Altroo não utiliza seus dados para fins publicitários ou comerciais.",
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
            labelText: "Armazenamento e Segurança dos Dados",
            labelFont: .sfPro,
            labelType: .title3,
            labelColor: .blue20,
            labelWeight: .medium
        )
        
        return label
    }()
    private let DataStorageSecurityText: StandardLabel = {
        let label = StandardLabel(
            labelText: "Os dados são armazenados em nuvem pessoal, atrelada à conta do dispositivo do usuário. \n\nIsso significa que apenas o próprio usuário tem acesso direto às suas informações, garantindo um controle individual e seguro. \n\nO Altroo adota medidas técnicas de segurança para proteger as informações contra acessos não autorizados, perda, uso indevido ou divulgação indevida. \n\nMesmo com essas medidas, é importante ressaltar que nenhum sistema é totalmente livre de riscos, e recomendamos que o usuário mantenha seus dispositivos protegidos com senhas seguras.",
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
            labelText: "Compartilhamento de Informações",
            labelFont: .sfPro,
            labelType: .title3,
            labelColor: .blue20,
            labelWeight: .medium
        )
        
        return label
    }()
    private let InformationSharingText: StandardLabel = {
        let label = StandardLabel(
            labelText: "O Altroo não compartilha dados pessoais com terceiros sem o consentimento do usuário. \n\nO compartilhamento de informações ocorre apenas entre cuidadores e familiares autorizados, dentro do próprio ambiente do aplicativo, com o objetivo de coordenar o cuidado do assistido. \n\nNenhuma informação é vendida, trocada ou utilizada para fins externos ao propósito do app.",
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
            labelText: "Direitos dos Usuários",
            labelFont: .sfPro,
            labelType: .title3,
            labelColor: .blue20,
            labelWeight: .medium
        )
        
        return label
    }()
    private let UserRightsText: StandardLabel = {
        let label = StandardLabel(
            labelText: "O usuário tem o direito de:\n• Acessar as informações pessoais armazenadas no aplicativo;\n• Corrigir, atualizar ou excluir seus dados;\n• Revogar o consentimento para o uso de suas informações a qualquer momento;\n• Solicitar a exclusão completa de sua conta e dos dados vinculados.\n• Para exercer esses direitos, entre em contato pelo canal de suporte do Altroo disponível no aplicativo ou no site oficial.",
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
            labelText: "Retenção de Dados",
            labelFont: .sfPro,
            labelType: .title3,
            labelColor: .blue20,
            labelWeight: .medium
        )
        
        return label
    }()
    private let DataRetentionText: StandardLabel = {
        let label = StandardLabel(
            labelText: "Os dados são mantidos apenas pelo tempo necessário para cumprir as finalidades do aplicativo ou até que o usuário solicite sua exclusão. \n\nApós a exclusão da conta, as informações são removidas de forma definitiva e não ficam disponíveis para recuperação.",
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
            labelText: "Alterações nesta Política",
            labelFont: .sfPro,
            labelType: .title3,
            labelColor: .blue20,
            labelWeight: .medium
        )
        
        return label
    }()
    private let ChangesPolicyText: StandardLabel = {
        let label = StandardLabel(
            labelText: "Esta Política de Privacidade pode ser atualizada periodicamente para refletir melhorias no aplicativo ou mudanças legais. \n\nO Altroo notificará os usuários sobre alterações significativas por meio do próprio aplicativo. A data da última atualização estará sempre disponível no início deste documento.",
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
            labelText: "Contato",
            labelFont: .sfPro,
            labelType: .title3,
            labelColor: .blue20,
            labelWeight: .medium
        )
        
        return label
    }()
    private let ContactText: StandardLabel = {
        let label = StandardLabel(
            labelText: "Em caso de dúvidas, solicitações ou reclamações relacionadas à privacidade ou ao tratamento de dados, entre em contato com nossa equipe de suporte através do e-mail:\n\n📩 altroohealthcare@gmail.com",
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

//#Preview {
//    PrivacyViewController()
//}
