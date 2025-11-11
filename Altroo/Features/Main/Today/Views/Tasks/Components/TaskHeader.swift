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
        let capsule = CapsuleIconView(iconName: "pencil.and.list.clipboard", text: "Ver Tudo")
        capsule.enablePressEffect()
        capsule.onTap = { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self?.didTapPeriodTag()
            }
        }
        return capsule
    }()

    private lazy var plusButton: PlusButton = {
        let plusButton = PlusButton()
        plusButton.enablePressEffect()
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
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 5)
        ])
    }
    
    @objc private func didTapPlusButton() {
        delegate?.didTapAddTask()
    }
    
    @objc private func didTapPeriodTag() {
        delegate?.didTapSeeTask()
    }
}

//#Preview {
//    TaskHeader()
//}
