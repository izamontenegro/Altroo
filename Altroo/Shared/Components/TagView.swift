//
//  TagView.swift
//  Altroo
//
//  Created by Raissa Parente on 16/10/25.
//
import UIKit

import UIKit

final class TagView: UIView {
    
    private let iconView = UIImageView()
    private let label = StandardLabel(
        labelText: "",
        labelFont: .sfPro,
        labelType: .subHeadline,
        labelColor: .blue20,
        labelWeight: .regular
    )
    
    var defaultLabelColor: UIColor = .blue20
    var defaultBackgroundColor: UIColor = .blue80
    var defaultIconTintColor: UIColor = .blue20
    
    private let selectedLabelColor: UIColor = .black10
    private let selectedBackgroundColor: UIColor = .black40.withAlphaComponent(0.5)
    private let selectedIconTintColor: UIColor = .black10
    
    private var isSelectedAppearance = false
    
    var text: String {
        didSet { label.text = text }
    }
    
    var iconName: String {
        didSet { iconView.image = UIImage(systemName: iconName) }
    }
    
    init(text: String, iconName: String) {
        self.text = text
        self.iconName = iconName
        super.init(frame: .zero)
        setupUI()
        applyDefaultAppearance()
    }
    
    required init?(coder: NSCoder) {
        self.text = ""
        self.iconName = "alarm.fill"
        super.init(coder: coder)
        setupUI()
        applyDefaultAppearance()
    }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 4
        clipsToBounds = true
        
        iconView.image = UIImage(systemName: iconName)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(iconView)
        addSubview(label)
        
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            iconView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            iconView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            
            label.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 5),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
        ])
    }
    
    private func applyDefaultAppearance() {
        backgroundColor = defaultBackgroundColor
        label.labelColor = defaultLabelColor
        label.configureLabelColor()
        iconView.tintColor = defaultIconTintColor
    }
    
    private func applySelectedAppearance() {
        backgroundColor = selectedBackgroundColor
        label.labelColor = selectedLabelColor
        label.configureLabelColor()
        iconView.tintColor = selectedIconTintColor
    }
    
    func setSelectedAppearance(_ selected: Bool) {
        isSelectedAppearance = selected
        if selected {
            applySelectedAppearance()
        } else {
            applyDefaultAppearance()
        }
    }
}
