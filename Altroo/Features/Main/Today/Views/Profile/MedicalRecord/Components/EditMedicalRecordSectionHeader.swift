//
//  EditMedicalRecordSectionHeader.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/10/25.
//

import UIKit

class EditMedicalRecordSectionHeader: UIView {
    let title: String
    let subtitle: String
    
    init(title: String, subtitle: String) {
        self.title = title
        self.subtitle = subtitle
        super.init(frame: .zero)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        let titleLabel = StandardLabel(labelText: title, labelFont: .sfPro, labelType: .title2, labelColor: .blue20, labelWeight: .semibold)
        titleLabel.numberOfLines = 0
        
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        
        let subtitleLabel = StandardLabel(labelText: subtitle, labelFont: .sfPro, labelType: .body, labelColor: .black30, labelWeight: .regular)
        
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.spacing = 4
        
        vStack.addArrangedSubview(titleLabel)
        vStack.addArrangedSubview(subtitleLabel)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(vStack)
        
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16) // comentário: define margens internas da view
               vStack.isLayoutMarginsRelativeArrangement = true // comentário: faz o stack respeitar as margens do container
               vStack.layoutMargins = .zero // comentário: mantemos as margens no container; aqui deixamos zero no stack

               NSLayoutConstraint.activate([
                   vStack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
                   vStack.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
                   vStack.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
                   vStack.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
               ])
    }
}
