//
//  ProfileToolbar.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 14/10/25.
//

import UIKit

protocol ProfileToolbarDelegate: AnyObject {
    func didTapProfileView()
    func didTapEditCapsuleView()
}

class ProfileToolbarContainer: UIView {
    
    weak var delegate: ProfileToolbarDelegate?

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
        capsuleButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 150),
            
            headerProfile.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: -25),
            headerProfile.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            headerProfile.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            headerProfile.heightAnchor.constraint(equalToConstant: 100),
            
            capsuleButton.centerYAnchor.constraint(equalTo: headerProfile.topAnchor, constant: 50),
            capsuleButton.trailingAnchor.constraint(equalTo: headerProfile.trailingAnchor),
            capsuleButton.heightAnchor.constraint(equalToConstant: 31),
            capsuleButton.widthAnchor.constraint(equalToConstant: 137),
            
            bottomAnchor.constraint(equalTo: headerProfile.bottomAnchor, constant: 16)
        ])
    }

    private func setupGesture() {
        let tapProfileGesture = UITapGestureRecognizer(target: self, action: #selector(didTapProfileView))
        headerProfile.isUserInteractionEnabled = true
        headerProfile.addGestureRecognizer(tapProfileGesture)
        
        capsuleButton.enablePressEffect(withHaptics: true)
        capsuleButton.onTap = { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self?.didTapEditCapsuleView()
            }
        }
    }
    
    @objc private func didTapProfileView() {
        delegate?.didTapProfileView()
    }
    
    @objc private func didTapEditCapsuleView() {
        delegate?.didTapEditCapsuleView()
    }
}

// MARK: - Helpers
private extension CGFloat {
    func percentOfWidth(_ view: UIView) -> CGFloat {
        return view.bounds.width * (self / 100)
    }
    
    func percentOfHeight(_ view: UIView) -> CGFloat {
        return view.bounds.height * (self / 100)
    }
}

private extension Int {
    func percentOfWidth(_ view: UIView) -> CGFloat {
        return CGFloat(self) * view.bounds.width / 100
    }
    
    func percentOfHeight(_ view: UIView) -> CGFloat {
        return CGFloat(self) * view.bounds.height / 100
    }
}

//#Preview {
//    let stack = CoreDataStack.shared
//    let mock = CareRecipient(context: stack.context)
//    let personalData = PersonalData(context: stack.context)
//    personalData.name = "Raissa Parente"
//    mock.personalData = personalData
//
//    return ProfileToolbarContainer(careRecipient: mock)
//}

