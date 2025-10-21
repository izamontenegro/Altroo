//
//  WaterRecord.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 18/10/25.
//

import UIKit

class WaterRecord: UIView {
    var currentQuantity: String
    let goalQuantity: String
    
    init(currentQuantity: String, goalQuantity: String) {
        self.currentQuantity = currentQuantity
        self.goalQuantity = goalQuantity
        super.init(frame: .zero)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        let currentLabel = StandardLabel(
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
        
        let hStack = UIStackView(arrangedSubviews: [currentLabel, slashLabel, goalLabel])
        hStack.axis = .horizontal
        hStack.spacing = 4
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
    
    func updateQuantity(_ newQuantity: String) {
        currentQuantity = "\(newQuantity) / \(goalQuantity)"
    }
}

//#Preview {
//    WaterRecord(currentQuantity: "0,5", goalQuantity: "2L")
//}
