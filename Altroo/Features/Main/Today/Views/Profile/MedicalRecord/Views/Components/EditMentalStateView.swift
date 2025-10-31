//
//  EditMentalState.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 30/10/25.
//
import UIKit
import Combine

final class EditMentalStateView: UIView {
    let viewModel: EditMedicalRecordViewModel
    weak var delegate: EditMedicalRecordViewControllerDelegate?

    private var subscriptions = Set<AnyCancellable>()
    private var emotionalButtons: [UIButton] = []
    private var orientationButtons: [UIButton] = []

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

    private lazy var emotionalStack: UIStackView = {
        let buttons = emotionalStates.map { makeEmotionalButton(title: $0, isSelected: false) }
        emotionalButtons = buttons
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
        let rows: [(String, Bool)] = [
            ("Bem orientado", false),
            ("Desorientado em tempo", false),
            ("Desorientado em espaço", false),
            ("Desorientado em pessoas", false)
        ]
        let views = rows.map { makeCheckboxRow(text: $0.0, isOn: $0.1) }
        let stack = UIStackView(arrangedSubviews: views)
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
        bindViewModel()
        viewModel.loadInitialMentalStateFormState()
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

    private func bindViewModel() {
        viewModel.$mentalStateFormState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }

                if let emo = state.emotionalState?.rawValue {
                    self.selectEmotional(title: emo)
                } else {
                    self.selectEmotional(title: nil)
                }

                if let ori = state.orientationState?.rawValue {
                    self.selectOrientation(title: ori)
                } else {
                    self.selectOrientation(title: nil)
                }

                if let mem = state.memoryState?.rawValue,
                   self.memoryPopupButton.currentTitle != mem {
                    self.memoryPopupButton.setTitle(mem, for: .normal)
                }
            }
            .store(in: &subscriptions)
    }

    private func configureMenu() {
        let memoryActions: [UIAction] = [
            UIAction(title: "Mantida", handler: { [weak self] _ in
                self?.memoryPopupButton.setTitle("Mantida", for: .normal)
                self?.viewModel.updateMemoryState(MemoryEnum(rawValue: "Mantida"))
            }),
            UIAction(title: "Prejudicada", handler: { [weak self] _ in
                self?.memoryPopupButton.setTitle("Prejudicada", for: .normal)
                self?.viewModel.updateMemoryState(MemoryEnum(rawValue: "Prejudicada"))
            })
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
        button.accessibilityIdentifier = title

        button.addAction(UIAction { [weak self, weak button] _ in
            guard let self, let button else { return }
            self.selectEmotional(title: button.accessibilityIdentifier)
            self.viewModel.updateEmotionalState(
                button.accessibilityIdentifier.flatMap { EmotionalStateEnum(rawValue: $0) }
            )
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
        button.accessibilityIdentifier = text

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

        orientationButtons.append(button)

        button.addAction(UIAction { [weak self, weak button] _ in
            guard let self, let button else { return }
            self.selectOrientation(title: button.accessibilityIdentifier)
            self.viewModel.updateOrientationState(
                button.accessibilityIdentifier.flatMap { OrientationEnum(rawValue: $0) }
            )
        }, for: .touchUpInside)

        return container
    }

    private func selectEmotional(title: String?) {
        for b in emotionalButtons {
            let match = (b.accessibilityIdentifier == title)
            b.backgroundColor = match ? .blue40 : .white70
            b.setTitleColor(match ? .white : .blue40, for: .normal)
        }
    }

    private func selectOrientation(title: String?) {
        for b in orientationButtons {
            let match = (b.accessibilityIdentifier == title)
            b.backgroundColor = match ? .blue40 : .clear
            b.setImage(match ? UIImage(systemName: "checkmark") : nil, for: .normal)
        }
    }
}
