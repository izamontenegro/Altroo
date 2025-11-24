//
//  ColorsCardsSectionView.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 18/11/25.
//

import UIKit
import SwiftUI

final class ColorsCardsSectionView: UIView {
    
    private(set) var colorCards: [BasicNeedsColorCardHostingView] = []
    private let colors: [UIColor]
    private let titles: [String]
    private var currentSelectedIndex: Int?
    
    var onColorSelected: ((Int, UIColor) -> Void)?
    
    init(
        title: String,
        colors: [UIColor],
        titles: [String],
        selectedIndex: Int? = nil
    ) {
        precondition(colors.count == titles.count, "colors e titles precisam ter o mesmo tamanho")
        
        self.colors = colors
        self.titles = titles
        self.currentSelectedIndex = selectedIndex
        
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
        
        for (index, color) in colors.enumerated() {
            let title = titles[index]
            let isSelected = (currentSelectedIndex == index)
            
            let card = BasicNeedsColorCardHostingView(
                color: color,
                title: title,
                isSelected: isSelected,
                action: { [weak self] in
                    guard let self else { return }
                    self.currentSelectedIndex = index
                    self.onColorSelected?(index, color)
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
    
    func updateSelection(index: Int?) {
        currentSelectedIndex = index
        for (i, card) in colorCards.enumerated() {
            card.setSelected(i == index)
        }
    }
}

final class BasicNeedsColorCardHostingView: UIView {
    private var hostingController: UIHostingController<BasicNeedsColorCard>
    
    let color: UIColor
    fileprivate let titleText: String
    fileprivate let action: () -> Void
    
    init(color: UIColor,
         title: String,
         isSelected: Bool = false,
         action: @escaping () -> Void) {
        
        self.color = color
        self.titleText = title
        self.action = action
        
        let swiftUIView = BasicNeedsColorCard(
            colorName: color,
            title: title,
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
            colorName: color,
            title: titleText,
            isSelected: isSelected,
            action: action
        )
    }
}
