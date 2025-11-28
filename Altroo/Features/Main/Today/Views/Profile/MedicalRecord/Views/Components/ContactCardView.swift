//
//  ContactCardView.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 10/11/25.
//

import UIKit

final class ContactCardView: UIView {
    
    private let nameAndRelationLabel: StandardLabel
    private let phoneLabel: StandardLabel
    let copyButton: UIButton

    init(name: String, relation: String?, phone: String, copyTarget: Any?, copyAction: Selector) {
        self.nameAndRelationLabel = StandardLabel(
            labelText: {
                if let relation = relation, !relation.trimmingCharacters(in: .whitespaces).isEmpty {
                    return "\(name) (\(relation))"
                } else {
                    return name
                }
            }(),
            labelFont: .sfPro,
            labelType: .subHeadline,
            labelColor: .black20,
            labelWeight: .regular
        )
        self.phoneLabel = StandardLabel(
            labelText: phone,
            labelFont: .sfPro,
            labelType: .callOut,
            labelColor: .black10,
            labelWeight: .medium
        )
        self.copyButton = UIButton(type: .system)
        super.init(frame: .zero)

        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.spacing = 0
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        verticalStack.addArrangedSubview(nameAndRelationLabel)
        verticalStack.addArrangedSubview(phoneLabel)

        copyButton.translatesAutoresizingMaskIntoConstraints = false
        copyButton.setImage(UIImage(systemName: "rectangle.portrait.on.rectangle.portrait.fill"), for: .normal)
        copyButton.tintColor = .teal20
        copyButton.accessibilityLabel = "Copiar telefone"
        copyButton.accessibilityValue = phone
        if let copyTarget = copyTarget {
            copyButton.addTarget(copyTarget, action: copyAction, for: .touchUpInside)
        }

        let contentStack = UIStackView()
        contentStack.axis = .horizontal
        contentStack.alignment = .top
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.addArrangedSubview(verticalStack)
        contentStack.addArrangedSubview(copyButton)

        addSubview(contentStack)

        NSLayoutConstraint.activate([
            copyButton.widthAnchor.constraint(equalToConstant: 22),
            copyButton.heightAnchor.constraint(equalToConstant: 24),

            contentStack.topAnchor.constraint(equalTo: topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
