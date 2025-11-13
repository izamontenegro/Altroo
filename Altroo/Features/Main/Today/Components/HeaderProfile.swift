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
    private var profileName: String { return formatName(rawName) }
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
    
    // MARK: - Atualização de conteúdo
    func update(name: String) {
        rawName = name // dispara o didSet → refreshUI()
    }
    
    private func refreshUI() {
        let formatted = profileName
        nameLabel.text = formatted
        
        // Atualiza as iniciais do círculo
        let parts = formatted.split(separator: " ")
        let firstInitial = parts.first?.prefix(1) ?? ""
        let secondInitial = parts.dropFirst().first?.prefix(1) ?? ""
        let initials = profileName.getInitials()
        profileView.updateInitials(String(initials))
    }
    
    // MARK: - Helpers
    private func formatName(_ name: String) -> String {
        let components = name.split(separator: " ")
        guard !components.isEmpty else { return name }
        
        let first = String(components[0])
        
        if components.count == 1 {
            return first
        }
        
        let second = String(components[1])
        let abbreviatedSecond = second.count > 10 ? "\(second.prefix(1))." : second
        
        return "\(first) \(abbreviatedSecond)"
    }
}
