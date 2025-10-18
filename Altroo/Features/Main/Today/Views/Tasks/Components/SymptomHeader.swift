//
//  SymptomHeader.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 18/10/25.
//

import UIKit

protocol IntercurrenceHeaderDelegate: AnyObject {
    func didTapAddIntercurrence()
}

class IntercurrenceHeader: UIView {
    
    weak var delegate: IntercurrenceHeaderDelegate?
    
    private let titleLabel: StandardLabel = {
        let label = StandardLabel(
            labelText: "Intercorrência",
            labelFont: .sfPro,
            labelType: .title2,
            labelColor: .black10,
            labelWeight: .semibold
        )
        return label
    }()
    
    private lazy var plusButton: PlusButton = {
        let button = PlusButton()
        button.addTarget(self, action: #selector(didTapPlusButton), for: .touchUpInside)
        return button
    }()
    
    private let spacer: UIView = {
        let spacer = UIView()
        let spacerWidthConstraint = spacer.widthAnchor.constraint(equalToConstant: .greatestFiniteMagnitude)
        spacerWidthConstraint.priority = .defaultLow
        spacerWidthConstraint.isActive = true
        return spacer
    }()
    
    private lazy var hStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, spacer, plusButton])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    // MARK: - Layout
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
        delegate?.didTapAddIntercurrence()
    }
}

#Preview {
    IntercurrenceHeader()
}
