//
//  ProfileToolbar.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 14/10/25.
//

import UIKit

class ProfileToolbarContainer: UIView {
    
    var onProfileTap: (() -> Void)?
    var onEditTap: (() -> Void)?

    private lazy var headerProfile = HeaderProfile(name: careRecipient.personalData?.name ?? "Assistido")
    private let careRecipient: CareRecipient
    private let gradientView = GradientArcView()
    private let capsuleButton = CapsuleWithCircleView(
        text: "Editar Seções",
        textColor: .teal20,
        nameIcon: "pencil",
        nameIconColor: .pureWhite,
        circleIconColor: .teal20
    )
    
    init(careRecipient: CareRecipient, frame: CGRect = .zero) {
        self.careRecipient = careRecipient
        super.init(frame: frame)
        setupLayout()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(gradientView)
        addSubview(headerProfile)
        addSubview(capsuleButton)
        
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        headerProfile.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 400),
            
            headerProfile.topAnchor.constraint(equalTo: topAnchor, constant: 85),
            headerProfile.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            headerProfile.widthAnchor.constraint(equalToConstant: 350),
            headerProfile.heightAnchor.constraint(equalToConstant: 100),
            
            capsuleButton.bottomAnchor.constraint(equalTo: headerProfile.topAnchor, constant: 25),
            capsuleButton.trailingAnchor.constraint(equalTo: headerProfile.trailingAnchor, constant: 16),
            capsuleButton.heightAnchor.constraint(equalToConstant: 31),
            capsuleButton.widthAnchor.constraint(equalToConstant: 137)
        ])
    }
    
    private func setupGesture() {
        let tapProfileGesture = UITapGestureRecognizer(target: self, action: #selector(didTapProfileView))
        headerProfile.isUserInteractionEnabled = true
        headerProfile.addGestureRecognizer(tapProfileGesture)
        
        let tapEditGesture = UITapGestureRecognizer(target: self, action: #selector(didTapEditCapsuleView))
        capsuleButton.isUserInteractionEnabled = true
        capsuleButton.addGestureRecognizer(tapEditGesture)
    }
    
    @objc private func didTapProfileView() {
        onProfileTap?()
    }
    
    @objc private func didTapEditCapsuleView() {
        onEditTap?()
    }
}

#Preview {
    let stack = CoreDataStack.shared
    let mock = CareRecipient(context: stack.context)
    let personalData = PersonalData(context: stack.context)
    personalData.name = "Raissa Parente"
    mock.personalData = personalData

    return ProfileToolbarContainer(careRecipient: mock)
}

