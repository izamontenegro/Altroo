//
//  CheckColumnView.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 31/10/25.
//


import UIKit

final class CheckColumnView<Option>: UIView where Option: Hashable {
    private var optionButtons: [UIButton] = []
    private let options: [Option]
    private let titleProvider: (Option) -> String
    private let onSelect: (Option) -> Void
    private var selectedOption: Option?

    init(options: [Option],
         titleProvider: @escaping (Option) -> String,
         onSelect: @escaping (Option) -> Void) {
        self.options = options
        self.titleProvider = titleProvider
        self.onSelect = onSelect
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupUI() {
        let rows = options.map { makeRow(for: $0) }
        let stack = UIStackView(arrangedSubviews: rows)
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 12
        addSubview(stack)

        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func makeRow(for option: Option) -> UIView {
        let text = titleProvider(option)
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.blue20.cgColor
        button.backgroundColor = .clear
        button.tintColor = .white
        button.widthAnchor.constraint(equalToConstant: 18).isActive = true
        button.heightAnchor.constraint(equalToConstant: 18).isActive = true
        button.accessibilityIdentifier = text

        let label = StandardLabel(
            labelText: text,
            labelFont: .sfPro,
            labelType: .callOut,
            labelColor: .black10,
            labelWeight: .regular
        )

        let container = UIStackView(arrangedSubviews: [button, label])
        container.axis = .horizontal
        container.alignment = .center
        container.spacing = 10

        optionButtons.append(button)

        button.addAction(UIAction { [weak self, weak button] _ in
            guard let self, let button else { return }
            self.updateSelection(for: option)
            self.onSelect(option)
        }, for: .touchUpInside)

        return container
    }

    func updateSelection(for option: Option) {
        selectedOption = option
        let selectedText = titleProvider(option)

        for button in optionButtons {
            let match = button.accessibilityIdentifier == selectedText
            button.backgroundColor = match ? .blue20 : .clear
            button.layer.borderColor = UIColor.blue20.cgColor
            button.tintColor = .pureWhite

            if match {
                let config = UIImage.SymbolConfiguration(pointSize: 9, weight: .bold)
                button.setImage(UIImage(systemName: "checkmark", withConfiguration: config), for: .normal)
            } else {
                button.setImage(nil, for: .normal)
            }
        }
    }

    func clearSelection() {
        selectedOption = nil
        for button in optionButtons {
            button.backgroundColor = .clear
            button.setImage(nil, for: .normal)
        }
    }
}