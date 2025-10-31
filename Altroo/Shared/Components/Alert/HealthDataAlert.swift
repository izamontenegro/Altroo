//
//  HealthDataAlert.swift
//  Altroo
//
//  Created by Marcelle Ribeiro Queiroz on 30/10/25.
//

import UIKit

class HealthDataAlert: UIView {
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let title: StandardLabel = StandardLabel(
        labelText: "Sua privacidade é nossa prioridade",
        labelFont: .comfortaa, labelType: .title2, labelColor: .pureWhite, labelWeight: .semibold
    )
    let text: StandardLabel = StandardLabel(
        labelText: "As informações de saúde do assistido são armazenadas em nuvem pessoal vinculada à conta privada do seu dispositivo, garantindo privacidade e proteção.",
        labelFont: .sfPro, labelType: .body, labelColor: .black10, labelWeight: .regular
    )
    
    let image: UIImageView = UIImageView(image: UIImage(systemName: "lock.fill"))
    let container = UIView()
    
    let linkPrivacy: StandardLabel = StandardLabel(
        labelText: "Política de Privacidade e Proteção",
        labelFont: .sfPro, labelType: .body,
        labelColor: .blue30, labelWeight: .semibold
    )
    let linkPolicy: StandardLabel = StandardLabel(
        labelText: "Aviso Legal",
        labelFont: .sfPro, labelType: .body,
        labelColor: .blue30, labelWeight: .semibold
    )
    
    func setupUI() {
        
        backgroundColor = .pureWhite
        widthAnchor.constraint(equalToConstant: 338).isActive = true
        heightAnchor.constraint(equalToConstant: 500).isActive = true
        layer.cornerRadius = 16
        layer.masksToBounds = true
        
        title.numberOfLines = 0
        title.textAlignment = .center
        title.backgroundColor = .blue20
        title.heightAnchor.constraint(equalToConstant: 100).isActive = true
        title.widthAnchor.constraint(equalToConstant: 340).isActive = true
        title.translatesAutoresizingMaskIntoConstraints = false
        addSubview(title)
        
        container.backgroundColor = .blue20
        container.layer.cornerRadius = 10
        container.translatesAutoresizingMaskIntoConstraints = false
        container.widthAnchor.constraint(equalToConstant: 300).isActive = true
        container.heightAnchor.constraint(equalToConstant: 170).isActive = true
        addSubview(container)
        
        image.tintColor = .pureWhite
        image.contentMode = .scaleAspectFit
        image.widthAnchor.constraint(equalToConstant: 115).isActive = true
        image.heightAnchor.constraint(equalToConstant: 115).isActive = true
        image.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(image)
        
        text.numberOfLines = 0
        text.textAlignment = .center
        text.widthAnchor.constraint(equalToConstant: 300).isActive = true
        text.translatesAutoresizingMaskIntoConstraints = false
        addSubview(text)
        
        linkPrivacy.numberOfLines = 0
        linkPrivacy.textAlignment = .center
        linkPrivacy.translatesAutoresizingMaskIntoConstraints = false
        addSubview(linkPrivacy)
        
        linkPolicy.numberOfLines = 0
        linkPolicy.textAlignment = .center
        linkPolicy.translatesAutoresizingMaskIntoConstraints = false
        addSubview(linkPolicy)
        
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            title.topAnchor.constraint(equalTo: topAnchor),
            
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 24),
            image.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            text.centerXAnchor.constraint(equalTo: centerXAnchor),
            text.topAnchor.constraint(equalTo: container.bottomAnchor, constant: 16),
            
            linkPrivacy.centerXAnchor.constraint(equalTo: centerXAnchor),
            linkPrivacy.topAnchor.constraint(equalTo: text.bottomAnchor, constant: 24),
            
            linkPolicy.centerXAnchor.constraint(equalTo: centerXAnchor),
            linkPolicy.topAnchor.constraint(equalTo: linkPrivacy.bottomAnchor, constant: 8),
        ])
    }
}
 
#Preview {
    HealthDataAlert()
}
