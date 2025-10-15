//
//  ProfileToolbar.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 14/10/25.
//

import UIKit

class ProfileToolbarContainer: UIView {
    
    private let gradientView = GradientArcView()
    private let headerProfile = HeaderProfile(name: "Karlisson Oliveira")
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(gradientView)
        addSubview(headerProfile)
        
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        headerProfile.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 400),
            
            headerProfile.topAnchor.constraint(equalTo: topAnchor, constant: 122),
            headerProfile.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            headerProfile.widthAnchor.constraint(equalToConstant: 350),
            headerProfile.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}

#Preview {
    ProfileToolbarContainer()
}
