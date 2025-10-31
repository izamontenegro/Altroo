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
    
    let titleLabel: StandardLabel = {
        let label = StandardLabel(
            labelText: "Aviso Legal",
            labelFont: .sfPro,
            labelType: .title2,
            labelColor: .black10,
            labelWeight: .semibold
        )
        return label
    }()
    let policyText: StandardLabel = {
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
    
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.alwaysBounceVertical = true
        scroll.showsVerticalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        
        return scroll
    }()
    
    lazy var vStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, policyText])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private func setupUI() {
        scrollView.addSubview(vStack)
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            vStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            vStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            vStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            vStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
}

//#Preview {
//    PolicyViewController()
//}
