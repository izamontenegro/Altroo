//
//  PolicyViewController.swift
//  Altroo
//
//  Created by Marcelle Ribeiro Queiroz on 29/10/25.
//

import UIKit

class PolicyViewController: GradientNavBarViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .pureWhite
        
        setupUI()
    }
    
    private let titleLabel: StandardLabel = {
        let label = StandardLabel(
            labelText: "Aviso Legal",
            labelFont: .sfPro,
            labelType: .title2,
            labelColor: .black10,
            labelWeight: .semibold
        )
        return label
    }()
    private let policyText: StandardLabel = {
        let label = StandardLabel(
            labelText: "O Altroo é um aplicativo desenvolvido para auxiliar cuidadores na organização e no acompanhamento das atividades de cuidado com seus assistidos. \n\nO aplicativo tem como objetivo facilitar a comunicação e o registro das rotinas de cuidado, contribuindo para um acompanhamento mais eficiente e colaborativo. \n\nO Altroo não é um dispositivo ou serviço médico, e seu uso não deve ser interpretado como orientação, diagnóstico ou tratamento médico oferecido por seus desenvolvedores ou proprietários. \n\nNenhuma informação, alerta ou dado gerado pelo aplicativo deve ser considerado clinicamente preciso ou substituto de aconselhamento profissional de saúde. \n\nSe você tiver qualquer dúvida sobre uma condição médica, consulte um profissional de saúde qualificado. \n\nSe acreditar que você ou a pessoa sob seus cuidados possa estar enfrentando uma situação médica, procure atendimento médico imediatamente. \n\nVocê nunca deve atrasar, ignorar ou interromper um tratamento médico com base em informações obtidas pelo uso do Altroo.",
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
        view.addSubview(policyText)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        policyText.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Header
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // policy text
            policyText.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            policyText.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            policyText.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
    }
}

//#Preview {
//    PolicyViewController()
//}
