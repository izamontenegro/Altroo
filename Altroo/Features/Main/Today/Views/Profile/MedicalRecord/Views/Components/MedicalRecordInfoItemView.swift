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
    private let secondaryDescription: String?
    
    init(infotitle: String, infoDescription: String) {
        self.infotitle = infotitle
        self.infoDescription = infoDescription
        self.secondaryDescription = nil
        super.init(frame: .zero)
        setupLayout()
    }
    
    init(infotitle: String, primaryText: String, secondaryText: String) {
        self.infotitle = infotitle
        self.infoDescription = primaryText
        self.secondaryDescription = secondaryText
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        self.infotitle = "title"
        self.infoDescription = "description"
        self.secondaryDescription = nil
        super.init(coder: coder)
        setupLayout()
    }
    
    private func setupLayout() {
        let titleLabel = StandardLabel(
                labelText: infotitle,
                labelFont: .sfPro,
                labelType: .body,
                labelColor: .blue20,
                labelWeight: .regular
            )
        
        let primaryLabel = StandardLabel(
            labelText: infoDescription,
            labelFont: .sfPro,
            labelType: .body,
            labelColor: .black10,
            labelWeight: .regular
        )
        primaryLabel.numberOfLines = 0
        
        let secondaryLabel: StandardLabel? = {
            guard let secondary = secondaryDescription else { return nil }
            let label = StandardLabel(
                labelText: secondary,
                labelFont: .sfPro,
                labelType: .callOut,
                labelColor: .black40,
                labelWeight: .regular
            )
            return label
        }()
        
        var arrangedSubviews: [UIView] = [titleLabel, primaryLabel]
        if let secondaryLabel = secondaryLabel {
            arrangedSubviews.append(secondaryLabel)
        }
        
        let stack = UIStackView(arrangedSubviews: arrangedSubviews)
        stack.axis = .vertical
        stack.spacing = 4
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
