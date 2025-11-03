//
//  MedicalRecordInformationView.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 12/10/25.
//

import UIKit

final class MedicalRecordInfoItemView: UIView {
    
    private let infotitle: String
    private let infoDescription: String
    
    init(infotitle: String, infoDescription: String) {
        self.infoDescription = infoDescription
        self.infotitle = infotitle
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        self.infoDescription = "description"
        self.infotitle = "title"
        super.init(coder: coder)
        setupLayout()
    }
    
    private func setupLayout() {
        
        let titleLabel = StandardLabel(labelText: infotitle, labelFont: .sfPro, labelType: .body, labelColor: .blue20, labelWeight: .regular)
      
        let descriptionLabel = StandardLabel(labelText: infoDescription, labelFont: .sfPro, labelType: .body, labelColor: .black10, labelWeight: .regular)
        
        descriptionLabel.numberOfLines = 0
     
        let stack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stack.axis = .vertical
        stack.spacing = 6
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
