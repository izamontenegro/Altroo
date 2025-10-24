//
//  WaterRecord.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 18/10/25.
//

import UIKit

class WaterRecord: UIView {
    private var currentLabel: StandardLabel!
    private let goalQuantity: String
    private var editButton: UIButton!

    var onEditTap: (() -> Void)?
    
    init(currentQuantity: String, goalQuantity: String) {
        self.goalQuantity = goalQuantity
        super.init(frame: .zero)
        setupLayout(currentQuantity: currentQuantity)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout(currentQuantity: String) {
        currentLabel = StandardLabel(
            labelText: currentQuantity,
            labelFont: .sfPro,
            labelType: .title2,
            labelColor: .black10,
            labelWeight: .semibold
        )
        
        let slashLabel = StandardLabel(
            labelText: "/",
            labelFont: .sfPro,
            labelType: .title3,
            labelColor: .black10.withAlphaComponent(0.5),
            labelWeight: .regular
        )
        
        let goalLabel = StandardLabel(
            labelText: goalQuantity,
            labelFont: .sfPro,
            labelType: .subHeadline,
            labelColor: .black10.withAlphaComponent(0.7),
            labelWeight: .regular
        )
        
        editButton = UIButton(type: .system)
        editButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        editButton.tintColor = .teal20
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)

        let labelStack = UIStackView(arrangedSubviews: [currentLabel, slashLabel, goalLabel])
        labelStack.axis = .horizontal
        labelStack.spacing = 4
        labelStack.alignment = .center
        labelStack.distribution = .fill
        
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        
        let hStack = UIStackView(arrangedSubviews: [labelStack, spacer, editButton])
        hStack.axis = .horizontal
        hStack.spacing = 8
        hStack.alignment = .center
        hStack.distribution = .fill
        
        addSubview(hStack)
        hStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)
        ])
    }
    
    @objc private func editButtonTapped() {
        onEditTap?()
    }
}

//#Preview {
//    WaterRecord(currentQuantity: "0,5", goalQuantity: "2L")
//}
