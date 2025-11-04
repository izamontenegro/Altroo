//
//  StandardHeaderView.swift
//  Altroo
//
//  Created by Raissa Parente on 31/10/25.
//
import UIKit

final class StandardHeaderView: UIView {

    var titleLabel: StandardLabel
    var subtitleLabel: StandardLabel
    
    var titleText: String {
        get { titleLabel.text ?? "" }
        set { titleLabel.text = newValue }
    }

    var subtitleText: String {
        get { subtitleLabel.text ?? "" }
        set { subtitleLabel.text = newValue }
    }

    init(title: String, subtitle: String) {
        self.titleLabel = StandardLabel(
            labelText: title,
            labelFont: .sfPro,
            labelType: .title2,
            labelColor: .black10,
            labelWeight: .semibold
        )

        self.subtitleLabel = StandardLabel(
            labelText: subtitle,
            labelFont: .sfPro,
            labelType: .headline,
            labelColor: .black30,
            labelWeight: .regular
        )
        self.subtitleLabel.numberOfLines = 0

        super.init(frame: .zero)

        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)

        self.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            subtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func update(title: String? = nil, subtitle: String? = nil) {
        if let title = title {
            titleLabel.text = title
        }
        if let subtitle = subtitle {
            subtitleLabel.text = subtitle
        }
    }
}
