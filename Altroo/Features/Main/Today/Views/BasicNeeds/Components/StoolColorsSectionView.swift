//
//  StoolColorsSectionView.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 18/11/25.
//

import UIKit
import SwiftUI

final class ColorsCardsSectionView: UIView {
    
    private(set) var colorCards: [BasicNeedsColorCardHostingView] = []
    private let colors: [StoolColorsEnum]
    private var currentSelected: StoolColorsEnum?
    
    var onColorSelected: ((StoolColorsEnum) -> Void)?
    
    init(
        title: String,
        colors: [StoolColorsEnum],
        selectedColor: StoolColorsEnum? = nil
    ) {
        self.colors = colors
        self.currentSelected = selectedColor
        super.init(frame: .zero)
        setupLayout(title: title)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout(title: String) {
        translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = StandardLabel(
            labelText: title,
            labelFont: .sfPro,
            labelType: .callOut,
            labelColor: .black10,
            labelWeight: .semibold
        )
        
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = 6
        row.alignment = .fill
        row.distribution = .fillEqually
        row.translatesAutoresizingMaskIntoConstraints = false
        
        // monta os cards de cor exatamente como antes (sem scroll)
        for color in colors {
            let card = BasicNeedsColorCardHostingView(
                color: color,
                isSelected: currentSelected == color,
                action: { [weak self] in
                    guard let self else { return }
                    self.currentSelected = color
                    self.onColorSelected?(color)
                }
            )
            
            card.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                card.widthAnchor.constraint(equalToConstant: 68),
                card.heightAnchor.constraint(equalToConstant: 98)
            ])
            
            row.addArrangedSubview(card)
            colorCards.append(card)
        }
        
        let sectionStack = UIStackView(arrangedSubviews: [titleLabel, row])
        sectionStack.axis = .vertical
        sectionStack.alignment = .leading
        sectionStack.spacing = 16
        sectionStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(sectionStack)
        
        NSLayoutConstraint.activate([
            sectionStack.topAnchor.constraint(equalTo: topAnchor),
            sectionStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            sectionStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            sectionStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func updateSelection(_ selected: StoolColorsEnum?) {
        currentSelected = selected
        for card in colorCards {
            card.setSelected(card.colorEnum == selected)
        }
    }
}

final class BasicNeedsColorCardHostingView: UIView {
    private var hostingController: UIHostingController<BasicNeedsColorCard>
    
    let colorEnum: StoolColorsEnum
    fileprivate let colorName: UIColor
    fileprivate let titleText: String
    fileprivate let action: () -> Void
    
    init(color: StoolColorsEnum,
         isSelected: Bool = false,
         action: @escaping () -> Void) {
        
        self.colorEnum = color
        self.colorName = color.color
        self.titleText = color.displayText
        self.action = action
        
        let swiftUIView = BasicNeedsColorCard(
            colorName: colorName,
            title: titleText,
            isSelected: isSelected,
            action: action
        )
        
        hostingController = UIHostingController(rootView: swiftUIView)
        
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.backgroundColor = .clear
        
        addSubview(hostingController.view)
        
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setSelected(_ isSelected: Bool) {
        hostingController.rootView = BasicNeedsColorCard(
            colorName: colorName,
            title: titleText,
            isSelected: isSelected,
            action: action
        )
    }
}
