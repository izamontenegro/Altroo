//
//  HeaderProfile.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 14/10/25.
//

import UIKit

class HeaderProfile: UIView {
    
    let profileName: String
    var careRecipient: CareRecipient?
    
    private lazy var profileView: ProfileCareRecipient = {
        let view = ProfileCareRecipient(name: profileName, strokeColor: .pureWhite)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func makeContentStack() -> UIStackView {
        let name = StandardLabel(labelText: profileName, labelFont: .comfortaa, labelType: .title2, labelColor: .pureWhite, labelWeight: .bold)
        let label = StandardLabel(labelText: "Cuidando de:", labelFont: .comfortaa, labelType: .subHeadline, labelColor: .pureWhite, labelWeight: .regular)
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 3
        stack.addArrangedSubview(label)
        stack.addArrangedSubview(name)
        
        return stack
    }
    
    func makeCombinedLayout() -> UIStackView {
        let contentStack = makeContentStack()

        let horizontalStack = UIStackView()
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 12
        horizontalStack.alignment = .center
        horizontalStack.distribution = .fill
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        
        horizontalStack.addArrangedSubview(profileView)
        horizontalStack.addArrangedSubview(contentStack)
        
        return horizontalStack
    }

    init(name: String, careRecipient: CareRecipient? = nil) {
        self.profileName = name
        self.careRecipient = careRecipient
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        let finalLayout = makeCombinedLayout()
        addSubview(finalLayout)
        
        NSLayoutConstraint.activate([
            profileView.widthAnchor.constraint(equalToConstant: 70),
            profileView.heightAnchor.constraint(equalToConstant: 70)
        ])

        NSLayoutConstraint.activate([
            finalLayout.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            finalLayout.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            finalLayout.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            finalLayout.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12)
        ])
    }
}

//#Preview {
//    HeaderProfile(name: "Karlisson Oliveira")
//}
