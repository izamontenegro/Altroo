//
//  FeedingCardRecord.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 18/10/25.
//

import UIKit

class FeedingCardRecord: UIView {
    
    private let title: String
    private let status: FeedingStatus
    
    init(title: String, status: FeedingStatus) {
        self.title = title
        self.status = status
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        let titleLabel = StandardLabel(
            labelText: title,
            labelFont: .sfPro,
            labelType: .callOut,
            labelColor: .teal30,
            labelWeight: .medium
        )
        titleLabel.textAlignment = .center
        
        let capsuleIcon = CapsuleIconView(
            iconName: status.iconName,
            text: status == .completed ? "Total" :
                  status == .partial ? "Parcialmente" : "Não aceitou",
            mainColor: .teal30,
            accentColor: .teal80,
            contentInsets: UIEdgeInsets(top: 3.5, left: 10, bottom: 3.5, right: 10)
        )
        
        capsuleIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            capsuleIcon.widthAnchor.constraint(equalToConstant: 122),
            capsuleIcon.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        let vStack = UIStackView(arrangedSubviews: [titleLabel, capsuleIcon])
        vStack.axis = .vertical
        vStack.spacing = 10
        vStack.alignment = .leading
        
        addSubview(vStack)
        
        vStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            vStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            vStack.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 12),
            vStack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -12),
            vStack.topAnchor.constraint(lessThanOrEqualTo: topAnchor, constant: 8),
            vStack.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -8)

        ])
        
        layer.cornerRadius = 8
        backgroundColor = .teal80
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 70),
            widthAnchor.constraint(equalToConstant: 146)
        ])
    }
}

enum FeedingStatus {
    case completed
    case partial
    case pending
    
    var iconName: String {
        switch self {
        case .completed: return "circle.fill"
        case .partial: return "circle.righthalf.filled.inverse"
        case .pending: return "circle.dashed"
        }
    }
}

//#Preview {
//    FeedingCardRecord(title: "Café da manhã", status: .partial)
//}
