//
//  HorizontalCardScrollSectionView.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 18/11/25.
//
import UIKit

final class HorizontalCardScrollSectionView: UIView {
    
    private let titleLabel: StandardLabel
    private let scrollView = UIScrollView()
    private let row = UIStackView()
    
    init(
        title: String,
        cards: [UIView],
        scrollHeight: CGFloat = 170,
        spacing: CGFloat = 12,
        leadingPadding: CGFloat = 5,
        trailingContentInset: CGFloat = 32
    ) {
        self.titleLabel = StandardLabel(
            labelText: title,
            labelFont: .sfPro,
            labelType: .callOut,
            labelColor: .black10,
            labelWeight: .semibold
        )
        
        super.init(frame: .zero)
        
        setupLayout(
            cards: cards,
            scrollHeight: scrollHeight,
            spacing: spacing,
            leadingPadding: leadingPadding,
            trailingContentInset: trailingContentInset
        )
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout(
        cards: [UIView],
        scrollHeight: CGFloat,
        spacing: CGFloat,
        leadingPadding: CGFloat,
        trailingContentInset: CGFloat
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = false
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.clipsToBounds = false
        scrollView.contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 0,
            right: trailingContentInset
        )
        
        row.axis = .horizontal
        row.alignment = .fill
        row.spacing = spacing
        row.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(row)
        
        NSLayoutConstraint.activate([
            row.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: leadingPadding),
            row.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            row.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            row.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            row.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
        
        cards.forEach { card in
            row.addArrangedSubview(card)
        }
        
        let verticalStack = UIStackView(arrangedSubviews: [titleLabel, scrollView])
        verticalStack.axis = .vertical
        verticalStack.spacing = 12
        verticalStack.alignment = .fill
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        verticalStack.clipsToBounds = false
        
        addSubview(verticalStack)
        
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: topAnchor),
            verticalStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            verticalStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            verticalStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            scrollView.heightAnchor.constraint(equalToConstant: scrollHeight)
        ])
    }
}
