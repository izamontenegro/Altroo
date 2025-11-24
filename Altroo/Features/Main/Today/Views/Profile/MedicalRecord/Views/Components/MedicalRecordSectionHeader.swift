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
    private weak var editTarget: AnyObject?
    private let editAction: Selector?

    init(title: String, icon: String, editTarget: AnyObject?, editAction: Selector?) {
        self.title = title
        self.icon = icon
        self.editTarget = editTarget
        self.editAction = editAction
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

        // Botão de editar (quadradinho com caneta)
        let editButton = UIButton(type: .system)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        editButton.tintColor = .pureWhite
        editButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        if let target = editTarget, let action = editAction {
            editButton.addTarget(target, action: action, for: .touchUpInside)
        }

        let hStack = UIStackView(arrangedSubviews: [titleStackView, UIView(), editButton])
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.spacing = 8
        hStack.translatesAutoresizingMaskIntoConstraints = false

        headerView.addSubview(hStack)
        addSubview(headerView)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            hStack.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 12),
            hStack.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -8),
            hStack.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
    }
}
