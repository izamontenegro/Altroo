//
//  DayTagView.swift
//  Altroo
//
//  Created by Raissa Parente on 18/11/25.
//
import UIKit

final class DayTagView: UIView {
    
    private let label = StandardLabel(
        labelText: "",
        labelFont: .sfPro,
        labelType: .callOut,
        labelColor: .blue20,
        labelWeight: .regular
    )
    
    var defaultLabelColor: UIColor = .blue20
    var defaultBackgroundColor: UIColor = .blue80
    
    var text: String {
        didSet { label.text = text }
    }
    
    init(text: String) {
        self.text = text
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 8
        clipsToBounds = true
        
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6)
        ])
        
        backgroundColor = defaultBackgroundColor
        label.labelColor = defaultLabelColor
        label.configureLabelColor()
    }
}
