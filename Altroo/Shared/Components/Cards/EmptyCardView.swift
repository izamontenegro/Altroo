//
//  EmptyCardView.swift
//  Altroo
//
//  Created by Raissa Parente on 21/11/25.
//
import UIKit

final class EmptyCardView: UIView {
    
    let label = StandardLabel(
        labelText: "Nada aqui ainda",
        labelFont: .sfPro,
        labelType: .callOut,
        labelColor: .black30
    )
    
    init(text: String? = nil) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .pureWhite
        layer.cornerRadius = 10
        
        if let text { label.text = text }
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Layout.largeSpacing),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Layout.largeSpacing),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
