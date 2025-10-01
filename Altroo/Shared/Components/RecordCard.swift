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
    let addButtonPosition: Position = .bottom
    
    let addButton = PlusButton()
    var onAddButtonTap: (() -> Void)? //call closure using [weak self]
    
    let padding = 12.0
    
    init(frame: CGRect = .zero, title: String, iconName: String) {
        self.title = title
        self.iconName = iconName
        
        super.init(frame: frame)
        
        setupBackground()
        setupShadows()
        setupPlusButton()
    }

    convenience override init(frame: CGRect) {
        self.init(frame: frame,
                  title: "",
                  iconName: "questionmark.circle")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
            return CGSize(width: UIView.noIntrinsicMetric, height: 85)
        }
    
    func setupBackground() {
        backgroundColor = .white
        layer.cornerRadius = 12
        
        let header = makeHeader()
        addSubview(header)
        
        NSLayoutConstraint.activate([
            header.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            header.topAnchor.constraint(equalTo: topAnchor, constant: padding),
        ])
    }
    
    func setupShadows() {
        layer.shadowColor = UIColor(resource: .blue40).cgColor
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 5, height: 5)
    }
    
    func setupPlusButton() {
        guard addButtonPosition != .none else { return }
        
        addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            addButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        if addButtonPosition == .bottom {
            addButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding).isActive = true
        } else {
            addButton.topAnchor.constraint(equalTo: topAnchor, constant: padding).isActive = true
        }
        
        addButton.addTarget(self, action: #selector(buttonWasTapped), for: .touchUpInside)

    }
    
    func makeHeader() -> UIStackView {
        let label = StandardLabel(labelText: title, labelFont: .sfPro, labelType: .h1, labelColor: .blue, labelWeight: .medium)
        
        let icon = PulseIcon(iconName: "waterbottle.fill", color: UIColor(resource: .blue30), shadowColor: UIColor(resource: .blue60))
        
        let stack = UIStackView()
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(icon)
        stack.addArrangedSubview(label)
        
        return stack
    }
    
    @objc private func buttonWasTapped() {
        onAddButtonTap?()
    }
    
    enum Position {
        case top, bottom, none
    }
}

class RecordCardPreview: UIViewController {
    let card = RecordCard(title: "Hidratação", iconName: "waterbottle.fill")
    
    
    override func viewDidLoad() {
        view.backgroundColor = .blue80
        
        view.addSubview(card)
        
        card.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            card.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            card.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            card.widthAnchor.constraint(equalToConstant: 370)
        ])

    }
}

#Preview {
//    let card = RecordCard(title: "Hidratação", iconName: "waterbottle.fill")
//    
//    return card
    
    RecordCardPreview()
}
