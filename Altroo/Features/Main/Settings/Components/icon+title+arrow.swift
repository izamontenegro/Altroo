//
//  icon+title+arrow.swift
//  Altroo
//
//  Created by Marcelle Ribeiro Queiroz on 24/11/25.
//

import UIKit

class IconTitleArrowButton: PrimaryStyleButton {
    
    var iconName: String
    var titleText: String

    private let leftIconView = UIImageView()
    private let titleLabelView = UILabel()
    private let rightArrowView = UIImageView(image: UIImage(systemName: "chevron.right"))
    private let contentStack = UIStackView()
    
    init(icon: String, title: String) {
        self.iconName = icon
        self.titleText = title
        super.init()
        
        translatesAutoresizingMaskIntoConstraints = false
        setupButton()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupButton() {
        backgroundColor = color
        layer.cornerRadius = 8
        clipsToBounds = true
    }

    private func setupLayout() {
        contentStack.axis = .horizontal
        contentStack.spacing = 8
        contentStack.alignment = .center
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.isUserInteractionEnabled = false

        addSubview(contentStack)

        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            contentStack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
        
        leftIconView.image = UIImage(systemName: iconName)
        leftIconView.tintColor = .pureWhite
        leftIconView.contentMode = .scaleAspectFit
        leftIconView.widthAnchor.constraint(equalToConstant: 22).isActive = true
        leftIconView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        leftIconView.isUserInteractionEnabled = false
        
        titleLabelView.text = titleText
        titleLabelView.textColor = .pureWhite
        titleLabelView.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabelView.isUserInteractionEnabled = false

        rightArrowView.tintColor = .pureWhite
        rightArrowView.contentMode = .scaleAspectFit
        rightArrowView.widthAnchor.constraint(equalToConstant: 22).isActive = true
        rightArrowView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        rightArrowView.isUserInteractionEnabled = false

        contentStack.addArrangedSubview(leftIconView)
        contentStack.addArrangedSubview(titleLabelView)
        contentStack.addArrangedSubview(rightArrowView)
    }
}

//#Preview {
//    IconTitleArrowButton(icon: "person.fill", title: "Meu Perfil")
//}
