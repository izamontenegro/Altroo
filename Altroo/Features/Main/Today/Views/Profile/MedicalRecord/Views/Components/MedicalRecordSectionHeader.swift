//
//  MedicalRecordSectionHeader.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 23/11/25.
//
import UIKit

class MedicalRecordSectionHeader: UIView {
    let title: String
    let icon: String
    
    init(title: String, icon: String) {
        self.title = title
        self.icon = icon
        super.init(frame: .zero)
        
        setupHeader()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHeader() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.blue30
        headerView.layer.cornerRadius = 4
        headerView.translatesAutoresizingMaskIntoConstraints = false

        let iconImageView = UIImageView(image: UIImage(systemName: icon))
        iconImageView.tintColor = .pureWhite
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 19).isActive = true

        let titleLabel = StandardLabel(
            labelText: title,
            labelFont: .sfPro,
            labelType: .body,
            labelColor: .pureWhite,
            labelWeight: .semibold
        )

        let titleStackView = UIStackView(arrangedSubviews: [iconImageView, titleLabel])
        titleStackView.axis = .horizontal
        titleStackView.spacing = 8
        titleStackView.translatesAutoresizingMaskIntoConstraints = false

        headerView.addSubview(titleStackView)
        addSubview(headerView)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            titleStackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 12),
            titleStackView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
    }
}
