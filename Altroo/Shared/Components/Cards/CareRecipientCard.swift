//
// ProfileCareRecipient.swift
// Altroo
//
// Created by Layza Maria Rodrigues Carneiro on 12/10/25.
//

import UIKit

class CareRecipientCard: UIView {
    
    let profileName: String
    let profileAge: Int
    var careRecipient: CareRecipient?
    
    private lazy var profileView: ProfileCareRecipient = {
        let view = ProfileCareRecipient(name: profileName)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func makeContentStack() -> UIStackView {
        let label = StandardLabel(labelText: profileName, labelFont: .comfortaa, labelType: .title2, labelColor: .blue20, labelWeight: .bold)
        let age = StandardLabel(labelText: "\(profileAge) anos", labelFont: .comfortaa, labelType: .title3, labelColor: .black10, labelWeight: .semibold)
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        stack.addArrangedSubview(label)
        stack.addArrangedSubview(age)
        
        return stack
    }
    
    func makeCombinedLayout() -> UIStackView {
        let contentStack = makeContentStack()
        
        let horizontalStack = UIStackView()
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 12
        horizontalStack.alignment = .center
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        
        horizontalStack.addArrangedSubview(profileView)
        horizontalStack.addArrangedSubview(contentStack)
        
        return horizontalStack
    }

    init(name: String, age: Int, careRecipient: CareRecipient? = nil, frame: CGRect = .zero) {
        self.profileName = name
        self.profileAge = age
        self.careRecipient = careRecipient
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        backgroundColor = .blue80
        layer.cornerRadius = 10
        clipsToBounds = true
        
        let finalLayout = makeCombinedLayout()
        addSubview(finalLayout)

        NSLayoutConstraint.activate([
            finalLayout.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            finalLayout.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            finalLayout.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            finalLayout.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12)
        ])
    }
}

#Preview {
    CareRecipientCard(name: "Karlisson Oliveira", age: 68, frame: CGRect(x: 0, y: 0, width: 300, height: 90))
}
