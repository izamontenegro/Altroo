//
//  RecordCard.swift
//  Altroo
//
//  Created by Raissa Parente on 30/09/25.
//

import UIKit

class RecordCard: InnerShadowView {
    
    let title: String
    let iconName: String
    let showPlusButton: Bool
    let contentContainer = UIView()
    
    var addButtonPosition: Position = .none
    let addButton = PlusButton()
    let waterCapsule: WaterCapsule
    var onAddButtonTap: (() -> Void)? //call closure using [weak self]
    
    let padding = 8.0
    let contentView: UIView?
    
    init(frame: CGRect = .zero, title: String, iconName: String, showPlusButton: Bool = true, addButtonPosition: Position = .top, contentView: UIView? = nil, waterText: String = "250ml" ) {
        self.title = title
        self.iconName = iconName
        self.showPlusButton = showPlusButton
        self.addButtonPosition = addButtonPosition
        self.contentView = contentView
        self.waterCapsule = WaterCapsule(text: waterText)
        
        super.init(frame: frame, color: .blue70)
        
        setupBackground()
        setupShadows()
        setupPlusButton()
        setupContentContainer()
    }
    
    convenience init(frame: CGRect) {
        self.init(frame: frame, title: "", iconName: "questionmark.circle")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 85)
    }
    
    func setupBackground() {
        backgroundColor = .pureWhite
        layer.cornerRadius = 12
        
        let header = makeHeader()
        addSubview(header)
        
        NSLayoutConstraint.activate([
            header.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            header.topAnchor.constraint(equalTo: topAnchor, constant: padding + 2),
        ])
    }
    
    func setupShadows() {
        layer.shadowColor = UIColor(resource: .blue70).cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 12
        layer.shadowOffset = CGSize(width: 5, height: 2)
    }
    
    func setupPlusButton() {
        let actionView: UIView = showPlusButton ? addButton : waterCapsule
        
        addSubview(actionView)
        actionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            actionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            actionView.heightAnchor.constraint(equalToConstant: 27)
        ])
        
        if addButtonPosition == .bottom {
            actionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding).isActive = true
        } else {
            actionView.topAnchor.constraint(equalTo: topAnchor, constant: padding).isActive = true
        }
        
        if showPlusButton {
            addButton.addTarget(self, action: #selector(buttonWasTapped), for: .touchUpInside)
        } else {
            let tap = UITapGestureRecognizer(target: self, action: #selector(buttonWasTapped))
            waterCapsule.isUserInteractionEnabled = true
            waterCapsule.addGestureRecognizer(tap)
        }
    }
    
    func makeHeader() -> UIStackView {
        let label = StandardLabel(labelText: title,
                                  labelFont: .sfPro,
                                  labelType: .title3,
                                  labelColor: .blue40,
                                  labelWeight: .medium)
        
        let icon = PulseIcon(iconName: iconName,
                             color: UIColor(resource: .blue30),
                             iconColor: UIColor(resource: .pureWhite),
                             shadowColor: UIColor(resource: .blue60))
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: 33),
            icon.heightAnchor.constraint(equalToConstant: 33)
        ])
        
        let stack = UIStackView()
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(icon)
        stack.addArrangedSubview(label)
        
        return stack
    }
    
    private func setupContentContainer() {
        guard let contentView = contentView else { return }
        
        addSubview(contentContainer)
        contentContainer.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentContainer.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            contentContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            contentContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            contentContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
        ])
        
        contentContainer.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: 0),
            contentView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: 0),
            contentView.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: 15),
            contentView.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 5)
        ])
    }
    
    @objc private func buttonWasTapped() {
        onAddButtonTap?()
    }

    enum Position {
        case top, bottom, none
    }
}

//#Preview {
//    let waterRecord = WaterRecord(currentQuantity: "0,5", goalQuantity: "2L")
//    let card = RecordCard(
//        title: "Hidratação",
//        iconName: "waterbottle.fill",
//        showPlusButton: false,
//        addButtonPosition: .top,
//        contentView: waterRecord
//    )
//    
//    return card
//}
