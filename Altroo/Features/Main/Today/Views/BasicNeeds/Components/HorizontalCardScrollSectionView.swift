//
//  HorizontalCardScrollSectionView.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 18/11/25.
//
import UIKit
import SwiftUI

final class BasicNeedsCardsScrollSectionView: UIView {
    
    private(set) var cards: [BasicNeedsCardHostingView] = []
    
    private let imageNames: [String]
    private let subtitles: [String]
    private let titles: [String]
    private var currentSelectedIndex: Int?
    
    private let scrollHeight: CGFloat
    private let spacing: CGFloat
    private let leadingPadding: CGFloat
    private let trailingContentInset: CGFloat
    
    var onCardSelected: ((Int) -> Void)?
    
    init(
        title: String,
        imageNames: [String],
        subtitles: [String],
        titles: [String],
        selectedIndex: Int? = nil,
        scrollHeight: CGFloat = 170,
        spacing: CGFloat = 12,
        leadingPadding: CGFloat = 5,
        trailingContentInset: CGFloat = 32
    ) {
        
        self.imageNames = imageNames
        self.subtitles = subtitles
        self.titles = titles
        self.currentSelectedIndex = selectedIndex
        self.scrollHeight = scrollHeight
        self.spacing = spacing
        self.leadingPadding = leadingPadding
        self.trailingContentInset = trailingContentInset
        
        super.init(frame: .zero)
        
        setupLayout(title: title)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout(title: String) {
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = false
        
        let titleLabel = StandardLabel(
            labelText: title,
            labelFont: .sfPro,
            labelType: .body,
            labelColor: .black10,
            labelWeight: .semibold
        )
        
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.clipsToBounds = false
        scrollView.contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 0,
            right: trailingContentInset
        )
        
        let row = UIStackView()
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
        
        for index in imageNames.indices {
            let imageName = imageNames[index]
            let subtitle = subtitles[index]
            let title = titles[index]
            let isSelected = (currentSelectedIndex == index)
            
            let card = BasicNeedsCardHostingView(
                imageName: imageName,
                subtitle: subtitle,
                title: title,
                isSelected: isSelected,
                action: { [weak self] in
                    guard let self else { return }
                    self.currentSelectedIndex = index
                    self.updateSelection(index: index)   // atualiza visual
                    self.onCardSelected?(index)
                }
            )
            
            card.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                card.widthAnchor.constraint(equalToConstant: 120),
                card.heightAnchor.constraint(equalToConstant: 160)
            ])
            
            row.addArrangedSubview(card)
            cards.append(card)
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
    
    /// Atualiza seleção de fora (ex: via viewModel)
    func updateSelection(index: Int?) {
        currentSelectedIndex = index
        for (i, card) in cards.enumerated() {
            card.setSelected(i == index)
        }
    }
}
final class BasicNeedsCardHostingView: UIView {
    private var hostingController: UIHostingController<BasicNeedsTemplateCard>
    
    let imageName: String
    let subtitleText: String
    let titleText: String
    private let action: () -> Void

    init(
        imageName: String,
        subtitle: String,
        title: String,
        isSelected: Bool = false,
        action: @escaping () -> Void
    ) {
        self.imageName = imageName
        self.subtitleText = subtitle
        self.titleText = title
        self.action = action
        
        let swiftUIView = BasicNeedsTemplateCard(
            imageName: imageName,
            subtitle: subtitle,
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
        hostingController.rootView = BasicNeedsTemplateCard(
            imageName: imageName,
            subtitle: subtitleText,
            title: titleText,
            isSelected: isSelected,
            action: action
        )
    }
}
