//
//  HeaderProfile.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 14/10/25.
//

import UIKit

class HeaderProfile: UIView {
    
    private var rawName: String {
        didSet {
            refreshUI()
        }
    }
    var careRecipient: CareRecipient?
    
    // Subviews armazenadas como propriedades para poder atualizá-las depois
    private let profileView = ProfileCareRecipient(name: "", strokeColor: .pureWhite)
    private let nameLabel = StandardLabel(
        labelText: "",
        labelFont: .comfortaa,
        labelType: .title2,
        labelColor: .pureWhite,
        labelWeight: .bold
    )
    private let subtitleLabel = StandardLabel(
        labelText: "Cuidando de:",
        labelFont: .comfortaa,
        labelType: .subHeadline,
        labelColor: .pureWhite,
        labelWeight: .regular
    )
    
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [subtitleLabel, nameLabel])
        stack.axis = .vertical
        stack.spacing = 3
        return stack
    }()
    
    private lazy var finalLayout: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [profileView, contentStack])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Init
    init(name: String, careRecipient: CareRecipient? = nil) {
        self.rawName = name
        self.careRecipient = careRecipient
        super.init(frame: .zero)
        setupLayout()
        refreshUI() // inicializa visualmente
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    private func setupLayout() {
        addSubview(finalLayout)
        
        profileView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileView.widthAnchor.constraint(equalToConstant: 70),
            profileView.heightAnchor.constraint(equalToConstant: 70),
            
            finalLayout.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            finalLayout.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            finalLayout.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            finalLayout.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12)
        ])
    }
    
    func update(name: String) {
        rawName = name
    }
    
    private func refreshUI() {
        nameLabel.text = rawName.abbreviatedName
        profileView.updateInitials(rawName.getInitials())
    }
}
