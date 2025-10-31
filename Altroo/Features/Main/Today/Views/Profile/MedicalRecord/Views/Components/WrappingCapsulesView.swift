//
//  WrappingCapsulesView.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 31/10/25.
//

import UIKit

final class WrappingCapsulesView: UIView {

    struct Style {
        var normalBackgroundColor: UIColor = .white70
        var selectedBackgroundColor: UIColor = .blue30
        var normalTitleColor: UIColor = .blue30
        var selectedTitleColor: UIColor = .pureWhite
        var horizontalSpacing: CGFloat = 12
        var verticalSpacing: CGFloat = 8
        var contentInsets: UIEdgeInsets = .init(top: 6, left: 12, bottom: 6, right: 12)
        var symbolPointSize: CGFloat = 13
        var font: UIFont = .systemFont(ofSize: 15, weight: .regular)
        var chipHeight: CGFloat = 26
    }

    private let titles: [String]
    private let didSelect: (String?) -> Void
    private let style: Style
    private var buttons: [UIButton] = []
    private(set) var selectedTitle: String?

    init(titles: [String], style: Style = Style(), didSelect: @escaping (String?) -> Void) {
        self.titles = titles
        self.style = style
        self.didSelect = didSelect
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        buildButtons()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func updateSelection(title: String?) {
        selectedTitle = title
        for button in buttons {
            let isSelected = (button.currentTitle == title)
            applyAppearance(for: button, isSelected: isSelected)
        }
        setNeedsLayout()
        invalidateIntrinsicContentSize()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard !buttons.isEmpty else { return }

        let maxWidth = bounds.width
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var lineHeight: CGFloat = 0

        for button in buttons {
            let targetSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: style.chipHeight)
            var size = button.systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: .fittingSizeLevel,
                verticalFittingPriority: .required
            )
            size.height = style.chipHeight

            if currentX > 0, currentX + size.width > maxWidth {
                currentX = 0
                currentY += lineHeight + style.verticalSpacing
                lineHeight = 0
            }

            button.frame = CGRect(origin: CGPoint(x: currentX, y: currentY), size: size)
            currentX += size.width + style.horizontalSpacing
            lineHeight = max(lineHeight, size.height)

            button.layer.cornerRadius = size.height / 2
        }
    }

    override var intrinsicContentSize: CGSize {
        guard !buttons.isEmpty else { return .zero }
        let maxWidth = bounds.width > 0 ? bounds.width : UIScreen.main.bounds.width - 32
        var currentX: CGFloat = 0
        var totalHeight: CGFloat = 0
        var lineHeight: CGFloat = 0
        var isFirstInLine = true

        for (idx, button) in buttons.enumerated() {
            let targetSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: style.chipHeight)
            var size = button.systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: .fittingSizeLevel,
                verticalFittingPriority: .required
            )
            size.height = style.chipHeight

            let neededWidth = isFirstInLine ? size.width : currentX + size.width
            if !isFirstInLine, neededWidth > maxWidth {
                totalHeight += lineHeight + style.verticalSpacing
                currentX = 0
                lineHeight = 0
                isFirstInLine = true
            }

            if isFirstInLine {
                currentX = size.width
                isFirstInLine = false
            } else {
                currentX += style.horizontalSpacing + size.width
            }
            lineHeight = max(lineHeight, size.height)

            if idx == buttons.count - 1 { totalHeight += lineHeight }
        }
        return CGSize(width: UIView.noIntrinsicMetric, height: totalHeight)
    }

    private func buildButtons() {
        for title in titles {
            let b = UIButton(type: .system)
            b.setTitle(title, for: .normal)
            b.titleLabel?.font = style.font
            b.contentEdgeInsets = style.contentInsets
            b.heightAnchor.constraint(equalToConstant: style.chipHeight).isActive = true
            b.layer.masksToBounds = true
            b.layer.cornerCurve = .continuous

            applyAppearance(for: b, isSelected: false)

            b.addAction(UIAction { [weak self, weak b] _ in
                guard let self, let b, let text = b.currentTitle else { return }
                let willSelect = (self.selectedTitle != text)
                let newSelection: String? = willSelect ? text : nil
                self.updateSelection(title: newSelection)
                self.didSelect(newSelection)
            }, for: .touchUpInside)

            addSubview(b)
            buttons.append(b)
        }
        setNeedsLayout()
        invalidateIntrinsicContentSize()
    }

    private func applyAppearance(for button: UIButton, isSelected: Bool) {
        button.backgroundColor = isSelected ? style.selectedBackgroundColor : style.normalBackgroundColor
        button.setTitleColor(isSelected ? style.selectedTitleColor : style.normalTitleColor, for: .normal)

        if isSelected {
            let cfg = UIImage.SymbolConfiguration(pointSize: style.symbolPointSize, weight: .semibold)
            let img = UIImage(systemName: "checkmark", withConfiguration: cfg)
            button.setImage(img, for: .normal)
            button.tintColor = style.selectedTitleColor
            button.semanticContentAttribute = .forceLeftToRight
        } else {
            button.setImage(nil, for: .normal)
        }
    }
}
