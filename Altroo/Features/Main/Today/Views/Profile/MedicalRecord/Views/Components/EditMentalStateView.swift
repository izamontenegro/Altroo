//
//  EditMentalState.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 30/10/25.
//
import UIKit

final class EditMentalStateView: UIView {
    let viewModel: EditMedicalRecordViewModel
    weak var delegate: EditMedicalRecordViewControllerDelegate?

    private let header: EditSectionHeaderView = {
        let header = EditSectionHeaderView(
            sectionTitle: "Estado Mental",
            sectionDescription: "Preencha os campos a seguir quanto aos dados básicos da pessoa cuidada.",
            sectionIcon: "brain.head.profile.fill"
        )
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()

    private let emotionalStates = ["Calmo", "Depressivo", "Agitado", "Agressivo", "Vívido", "Ansioso"]
    private var selectedEmotionalStates: Set<String> = ["Depressivo", "Agressivo", "Ansioso"]

    private lazy var emotionalStack: UIStackView = {
        let buttons = emotionalStates.map { makeEmotionalButton(title: $0, isSelected: selectedEmotionalStates.contains($0)) }
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var orientationTitleLabel: StandardLabel = {
        StandardLabel(
            labelText: "Orientação",
            labelFont: .sfPro,
            labelType: .headline,
            labelColor: .black10,
            labelWeight: .semibold
        )
    }()

    private lazy var orientationOptionsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            makeCheckboxRow(text: "Bem orientado", isOn: false),
            makeCheckboxRow(text: "Desorientado em tempo", isOn: true),
            makeCheckboxRow(text: "Desorientado em espaço", isOn: true),
            makeCheckboxRow(text: "Desorientado em pessoas", isOn: true)
        ])
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .fill
        return stack
    }()

    private lazy var memoryPopupButton: PopupMenuButton = {
        let button = PopupMenuButton(title: "Mantida")
        button.backgroundColor = .blue40
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 175).isActive = true
        return button
    }()

    private lazy var memorySection = FormSectionView(title: "Memória", content: memoryPopupButton)

    private lazy var formStack: UIStackView = {
        let emotionalSectionTitle = StandardLabel(
            labelText: "Estado Emocional",
            labelFont: .sfPro,
            labelType: .headline,
            labelColor: .black10,
            labelWeight: .semibold
        )

        let emotionalContainer = UIStackView(arrangedSubviews: [emotionalSectionTitle, emotionalStack])
        emotionalContainer.axis = .vertical
        emotionalContainer.alignment = .fill
        emotionalContainer.spacing = 12

        let orientationContainer = UIStackView(arrangedSubviews: [orientationTitleLabel, orientationOptionsStack])
        orientationContainer.axis = .vertical
        orientationContainer.alignment = .fill
        orientationContainer.spacing = 12

        let stack = UIStackView(arrangedSubviews: [
            emotionalContainer,
            orientationContainer,
            memorySection
        ])
        stack.axis = .vertical
        stack.spacing = 22
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    init(viewModel: EditMedicalRecordViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupUI()
        configureMenu()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupUI() {
        backgroundColor = .pureWhite
        addSubview(header)
        addSubview(formStack)

        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15),
            header.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            header.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            formStack.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 15),
            formStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            formStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            formStack.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -20)
        ])
    }

    private func configureMenu() {
        let memoryActions: [UIAction] = [
            UIAction(title: "Mantida", handler: { [weak self] _ in self?.memoryPopupButton.setTitle("Mantida", for: .normal) }),
            UIAction(title: "Prejudicada", handler: { [weak self] _ in self?.memoryPopupButton.setTitle("Prejudicada", for: .normal) })
        ]
        memoryPopupButton.menu = UIMenu(children: memoryActions)
        memoryPopupButton.showsMenuAsPrimaryAction = true
    }

    private func makeEmotionalButton(title: String, isSelected: Bool) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(isSelected ? .white : .blue40, for: .normal)
        button.backgroundColor = isSelected ? .blue40 : .white70
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.blue40.cgColor
        button.heightAnchor.constraint(equalToConstant: 36).isActive = true

        button.addAction(UIAction { [weak button] _ in
            guard let button else { return }
            let selected = button.backgroundColor == .blue40
            button.backgroundColor = selected ? .white70 : .blue40
            button.setTitleColor(selected ? .blue40 : .white, for: .normal)
        }, for: .touchUpInside)

        return button
    }

    private func makeCheckboxRow(text: String, isOn: Bool) -> UIView {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.blue40.cgColor
        button.backgroundColor = isOn ? .blue40 : .clear
        button.tintColor = .white
        button.setImage(isOn ? UIImage(systemName: "checkmark") : nil, for: .normal)
        button.setPreferredSymbolConfiguration(.init(pointSize: 14, weight: .bold), forImageIn: .normal)
        button.widthAnchor.constraint(equalToConstant: 22).isActive = true
        button.heightAnchor.constraint(equalToConstant: 22).isActive = true

        let label = StandardLabel(
            labelText: text,
            labelFont: .sfPro,
            labelType: .body,
            labelColor: .black10,
            labelWeight: .regular
        )

        let container = UIStackView(arrangedSubviews: [button, label])
        container.axis = .horizontal
        container.alignment = .center
        container.spacing = 12

        button.addAction(UIAction { [weak button] _ in
            guard let button else { return }
            let selected = button.backgroundColor == .blue40
            button.backgroundColor = selected ? .clear : .blue40
            button.setImage(selected ? nil : UIImage(systemName: "checkmark"), for: .normal)
        }, for: .touchUpInside)

        return container
    }
}
