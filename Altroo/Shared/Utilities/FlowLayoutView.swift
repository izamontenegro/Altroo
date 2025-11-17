//
//  FlowLayoutView.swift
//  Altroo
//
//  Created by Raissa Parente on 14/11/25.
//
import UIKit

final class FlowLayoutView: UIView {

    private let spacing: CGFloat = 8
    private var rows: [UIStackView] = []
    private var maxWidth: CGFloat
    private var storedViews: [UIView]


    init(views: [UIView], maxWidth: CGFloat) {
        self.maxWidth = maxWidth
        self.storedViews = views

        super.init(frame: .zero)
        
        setupRows(with: views, maxWidth: maxWidth)
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupRows(with views: [UIView], maxWidth: CGFloat) {
        var currentRow = newRow()
        var remainingWidth = maxWidth

        addSubview(currentRow)
        currentRow.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            currentRow.topAnchor.constraint(equalTo: topAnchor),
            currentRow.leadingAnchor.constraint(equalTo: leadingAnchor),
            currentRow.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor)
        ])

        var previousRow: UIStackView = currentRow

        for view in views {
            let buttonWidth = view.intrinsicContentSize.width + spacing

            if buttonWidth > remainingWidth {
                let newRowView = newRow()
                addSubview(newRowView)
                
                newRowView.translatesAutoresizingMaskIntoConstraints = false

                NSLayoutConstraint.activate([
                    newRowView.topAnchor.constraint(equalTo: previousRow.bottomAnchor, constant: spacing),
                    newRowView.leadingAnchor.constraint(equalTo: leadingAnchor),
                    newRowView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor)
                ])

                currentRow = newRowView
                previousRow = newRowView
                remainingWidth = maxWidth
            }

            currentRow.addArrangedSubview(view)
            remainingWidth -= view.intrinsicContentSize.width + spacing
        }

        bottomAnchor.constraint(equalTo: previousRow.bottomAnchor).isActive = true
    }


    private func newRow() -> UIStackView {
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = spacing
        row.alignment = .leading
        return row
    }
    
    func reload(with views: [UIView]? = nil) {
            let newViews = views ?? storedViews
            storedViews = newViews

            // 1. Remover stackviews antigos
            rows.forEach { $0.removeFromSuperview() }
            rows.removeAll()

            // 2. Remover constraints antigas
            self.removeConstraints(self.constraints)

            // 3. Reconstruir o layout
            setupRows(with: newViews, maxWidth: maxWidth)

            // 4. Forçar layout update
            setNeedsLayout()
            layoutIfNeeded()
        }
}
