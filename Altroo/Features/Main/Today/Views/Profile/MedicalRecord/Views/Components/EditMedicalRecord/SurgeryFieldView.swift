//
//  SurgeryFieldView.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 05/11/25.
//

import UIKit

class SurgeryInputView: UIView {

    private let nameField = StandardTextfield(placeholder: "Nome da cirurgia")

    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "name".localized
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor(resource: .black10)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "date".localized
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor(resource: .black10)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 28, weight: .semibold)
        button.tintColor = UIColor.systemBlue
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        translatesAutoresizingMaskIntoConstraints = false

        let nameStack = UIStackView(arrangedSubviews: [nameLabel, nameField])
        nameStack.axis = .vertical
        nameStack.spacing = 4
        nameStack.translatesAutoresizingMaskIntoConstraints = false

        let dateStack = UIStackView(arrangedSubviews: [dateLabel, datePicker])
        dateStack.axis = .vertical
        dateStack.spacing = 4
        dateStack.translatesAutoresizingMaskIntoConstraints = false

        let rowStack = UIStackView(arrangedSubviews: [nameStack, dateStack])
        rowStack.axis = .horizontal
        rowStack.spacing = 20
        rowStack.distribution = .fillEqually
        rowStack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(rowStack)
        addSubview(addButton)

        NSLayoutConstraint.activate([
            rowStack.topAnchor.constraint(equalTo: topAnchor),
            rowStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            rowStack.trailingAnchor.constraint(equalTo: trailingAnchor),

            addButton.topAnchor.constraint(equalTo: rowStack.bottomAnchor, constant: 16),
            addButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            addButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
