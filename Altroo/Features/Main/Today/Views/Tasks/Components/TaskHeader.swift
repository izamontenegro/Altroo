//
//  TaskHeader.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 16/10/25.
//

import UIKit

protocol TaskHeaderDelegate: AnyObject {
    func didTapAddTask()
    func didTapSeeTask()
}

class TaskHeader: UIView {
    
    weak var delegate: TaskHeaderDelegate?
    
    private let titleLabel: StandardLabel = {
        let label = StandardLabel(
            labelText: "Tarefas",
            labelFont: .sfPro,
            labelType: .title2,
            labelColor: .black10,
            labelWeight: .semibold
        )
        return label
    }()
    
    private lazy var periodTag: CapsuleIconView = {
        let currentPeriod = PeriodEnum.current
        let capsule = CapsuleIconView(iconName: currentPeriod.iconName, text: currentPeriod.displayName)
        
        capsule.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapPeriodTag))
        capsule.addGestureRecognizer(tapGesture)
        
        return capsule
    }()
    
    private lazy var plusButton: PlusButton = {
        let plusButton = PlusButton()
        plusButton.addTarget(self, action: #selector(didTapPlusButton), for: .touchUpInside)
        return plusButton
    }()

    private let spacer: UIView = {
        let spacer = UIView()
        let spacerWidthConstraint = spacer.widthAnchor.constraint(equalToConstant: .greatestFiniteMagnitude)
        spacerWidthConstraint.priority = .defaultLow
        spacerWidthConstraint.isActive = true
        return spacer
    }()

    private lazy var hStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, spacer, periodTag, plusButton])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    private func setupLayout() {
        addSubview(hStack)
        
        NSLayoutConstraint.activate([
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            hStack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -0),
            hStack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    @objc private func didTapPlusButton() {
        delegate?.didTapAddTask()
    }
    
    @objc private func didTapPeriodTag() {
        delegate?.didTapSeeTask()
    }
}

// MARK: - PeriodEnum
extension PeriodEnum {
    static var current: PeriodEnum {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 0..<6: return .overnight
        case 6..<12: return .morning
        case 12..<18: return .afternoon
        case 18..<24: return .night
        default: return .night
        }
    }
    
    var displayName: String {
        switch self {
        case .overnight: return "Madrugada"
        case .morning:   return "Manhã"
        case .afternoon: return "Tarde"
        case .night:     return "Noite"
        }
    }
    
    var localizedCapitalized: String {
        return displayName.capitalized
    }
}

#Preview {
    TaskHeader()
}
