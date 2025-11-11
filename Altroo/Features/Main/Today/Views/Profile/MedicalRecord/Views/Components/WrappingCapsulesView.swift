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
        var capsuleHeight: CGFloat = 26
    }

    private let capsuleTitles: [String]
    private let selectionHandler: (String?) -> Void
    private let style: Style
    private var capsuleButtons: [UIButton] = []
    private(set) var selectedTitle: String?

    init(titles: [String], style: Style = Style(), didSelect selectionHandler: @escaping (String?) -> Void) {
        self.capsuleTitles = titles
        self.style = style
        self.selectionHandler = selectionHandler
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        buildCapsuleButtons()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateSelection(with title: String?) {
        selectedTitle = title
        for button in capsuleButtons {
            let isSelected = (button.currentTitle == title)
            applyAppearance(for: button, isSelected: isSelected)
        }
        setNeedsLayout()
        invalidateIntrinsicContentSize()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard !capsuleButtons.isEmpty else { return }

        let maximumWidth = bounds.width
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var currentLineHeight: CGFloat = 0

        for button in capsuleButtons {
            let targetSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: style.capsuleHeight)
            var buttonSize = button.systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: .fittingSizeLevel,
                verticalFittingPriority: .required
            )
            buttonSize.height = style.capsuleHeight

            if currentX > 0, currentX + buttonSize.width > maximumWidth {
                currentX = 0
                currentY += currentLineHeight + style.verticalSpacing
                currentLineHeight = 0
            }

            button.frame = CGRect(origin: CGPoint(x: currentX, y: currentY), size: buttonSize)
            currentX += buttonSize.width + style.horizontalSpacing
            currentLineHeight = max(currentLineHeight, buttonSize.height)

            button.layer.cornerRadius = buttonSize.height / 2
        }
    }

    override var intrinsicContentSize: CGSize {
        guard !capsuleButtons.isEmpty else { return .zero }
        let maximumWidth = bounds.width > 0 ? bounds.width : UIScreen.main.bounds.width - 32
        var currentX: CGFloat = 0
        var totalHeight: CGFloat = 0
        var currentLineHeight: CGFloat = 0
        var isFirstButtonInLine = true

        for (index, button) in capsuleButtons.enumerated() {
            let targetSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: style.capsuleHeight)
            var buttonSize = button.systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: .fittingSizeLevel,
                verticalFittingPriority: .required
            )
            buttonSize.height = style.capsuleHeight

            let requiredWidth = isFirstButtonInLine ? buttonSize.width : currentX + buttonSize.width
            if !isFirstButtonInLine, requiredWidth > maximumWidth {
                totalHeight += currentLineHeight + style.verticalSpacing
                currentX = 0
                currentLineHeight = 0
                isFirstButtonInLine = true
            }

            if isFirstButtonInLine {
                currentX = buttonSize.width
                isFirstButtonInLine = false
            } else {
                currentX += style.horizontalSpacing + buttonSize.width
            }
            currentLineHeight = max(currentLineHeight, buttonSize.height)

            if index == capsuleButtons.count - 1 {
                totalHeight += currentLineHeight
            }
        }
        return CGSize(width: UIView.noIntrinsicMetric, height: totalHeight)
    }

    private func buildCapsuleButtons() {
        for title in capsuleTitles {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = style.font
            button.contentEdgeInsets = style.contentInsets
            button.heightAnchor.constraint(equalToConstant: style.capsuleHeight).isActive = true
            button.layer.masksToBounds = true
            button.layer.cornerCurve = .continuous

            applyAppearance(for: button, isSelected: false)

            button.addAction(UIAction { [weak self, weak button] _ in
                guard let self = self, let button = button, let text = button.currentTitle else { return }
                let shouldSelect = (self.selectedTitle != text)
                let newSelection: String? = shouldSelect ? text : nil
                self.updateSelection(with: newSelection)
                self.selectionHandler(newSelection)
            }, for: .touchUpInside)

            addSubview(button)
            capsuleButtons.append(button)
        }
        setNeedsLayout()
        invalidateIntrinsicContentSize()
    }

    private func applyAppearance(for button: UIButton, isSelected: Bool) {
        button.backgroundColor = isSelected ? style.selectedBackgroundColor : style.normalBackgroundColor
        button.setTitleColor(isSelected ? style.selectedTitleColor : style.normalTitleColor, for: .normal)

        if isSelected {
            let configuration = UIImage.SymbolConfiguration(pointSize: style.symbolPointSize, weight: .semibold)
            let image = UIImage(systemName: "checkmark", withConfiguration: configuration)
            button.setImage(image, for: .normal)
            button.tintColor = style.selectedTitleColor
            button.semanticContentAttribute = .forceLeftToRight
        } else {
            button.setImage(nil, for: .normal)
        }
    }
}
