//
//  EditSectionHeaderView.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 29/10/25.
//
import UIKit

final class EditSectionHeaderView: UIView {
    
    private let sectionTitle: String
    private let sectionIcon: String
    private let sectionDescription: String
    
    init(sectionTitle: String, sectionDescription: String, sectionIcon: String) {
        self.sectionDescription = sectionDescription
        self.sectionTitle = sectionTitle
        self.sectionIcon = sectionIcon
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        self.sectionDescription = "description"
        self.sectionTitle = "title"
        self.sectionIcon = "icon"
        super.init(coder: coder)
        setupLayout()
    }
    
    private func setupLayout() {
        let icon = UIImageView(image: UIImage(systemName: sectionIcon))
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.tintColor = .blue20
        
        let title = StandardLabel(labelText: sectionTitle, labelFont: .sfPro, labelType: .title2, labelColor: .blue20, labelWeight: .semibold)
        
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.spacing = 4
        hStack.translatesAutoresizingMaskIntoConstraints = false
        
        hStack.addArrangedSubview(icon)
        hStack.addArrangedSubview(title)
        
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: 24)
        ])
        
        let headerDescription = StandardLabel(labelText: sectionDescription, labelFont: .sfPro, labelType: .body, labelColor: .black30, labelWeight: .regular)
        headerDescription.numberOfLines = 0
        headerDescription.lineBreakMode = .byWordWrapping
        
        let mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.spacing = 4
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        mainStack.addArrangedSubview(hStack)
        mainStack.addArrangedSubview(headerDescription)
        
        NSLayoutConstraint.activate([
            headerDescription.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor)

        ])
        
        addSubview(mainStack)
    }
}
