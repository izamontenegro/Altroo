//
//  QuantityRecordContent.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 17/10/25.
//

import UIKit

class QuantityRecordContent: UIView {
    let quantity: Int
    
    init(quantity: Int) {
        self.quantity = quantity
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        let quantityLabel = StandardLabel(
            labelText: "\(quantity)",
            labelFont: .sfPro,
            labelType: .title2,
            labelColor: .black10,
            labelWeight: .semibold
        )
        
        let textLabel = StandardLabel(
            labelText: "vez(es)",
            labelFont: .sfPro,
            labelType: .subHeadline,
            labelColor: .black10.withAlphaComponent(0.7),
            labelWeight: .regular
        )
        
        let hStack = UIStackView(arrangedSubviews: [quantityLabel, textLabel])
        hStack.axis = .horizontal
        hStack.spacing = 3
        hStack.alignment = .center
        hStack.distribution = .fill
        
        addSubview(hStack)
        
        hStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)
        ])
    }
}

//#Preview {
//    QuantityRecordContent(quantity: 3)
//}
