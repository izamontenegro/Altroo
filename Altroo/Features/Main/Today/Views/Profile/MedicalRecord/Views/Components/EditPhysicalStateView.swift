//
//  EditPhysicalStateView.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 30/10/25.
//

import UIKit

final class EditPhysicalStateView: UIView {
    let viewModel: EditMedicalRecordViewModel
    weak var delegate: EditMedicalRecordViewControllerDelegate?

    private lazy var visionPopupButton: PopupMenuButton = {
        let button = PopupMenuButton(title: "Sem alterações")
        button.backgroundColor = .blue40
        return button
    }()

    private lazy var hearingPopupButton: PopupMenuButton = {
        let button = PopupMenuButton(title: "Com déficit")
        button.backgroundColor = .blue40
        return button
    }()

    private lazy var locomotionPopupButton: PopupMenuButton = {
        let button = PopupMenuButton(title: "Sem auxílio")
        button.backgroundColor = .blue40
        return button
    }()

    private let header: EditSectionHeaderView = {
        let header = EditSectionHeaderView(
            sectionTitle: "Estado Físico",
            sectionDescription: "Preencha os campos a seguir quanto aos dados básicos da pessoa cuidada.",
            sectionIcon: "figure.arms.open"
        )
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()

    private lazy var visionSection = FormSectionView(title: "Visão", content: visionPopupButton)
    private lazy var hearingSection = FormSectionView(title: "Audição", content: hearingPopupButton)
    private lazy var locomotionSection = FormSectionView(title: "Locomoção", content: locomotionPopupButton)

    private lazy var oralHealthTitleLabel: StandardLabel = {
        StandardLabel(
            labelText: "Saúde bucal",
            labelFont: .sfPro,
            labelType: .headline,
            labelColor: .black10,
            labelWeight: .semibold
        )
    }()

    private lazy var oralHealthOptionsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            makeOralHealthOptionRow(text: "Possui todos os dentes", isOn: false),
            makeOralHealthOptionRow(text: "Possui dentes faltando", isOn: true),
            makeOralHealthOptionRow(text: "Sem dentes", isOn: false),
            makeOralHealthOptionRow(text: "Usa dentadura", isOn: true),
            makeOralHealthOptionRow(text: "Usa aparelho ortodôntico", isOn: false)
        ])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 12
        return stack
    }()

    private lazy var senseRowStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [visionSection, hearingSection])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .top
        stack.distribution = .fillEqually
        return stack
    }()

    private lazy var formStack: UIStackView = {
        let oralHealthContainer = UIStackView(arrangedSubviews: [oralHealthTitleLabel, oralHealthOptionsStack])
        oralHealthContainer.axis = .vertical
        oralHealthContainer.alignment = .fill
        oralHealthContainer.spacing = 12

        let stack = UIStackView(arrangedSubviews: [
            senseRowStack,
            locomotionSection,
            oralHealthContainer
        ])
        
        NSLayoutConstraint.activate([
            locomotionSection.widthAnchor.constraint(equalToConstant: 175)
        ])
        
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 22
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    init(viewModel: EditMedicalRecordViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupUI()
        configureMenus()
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

    private func configureMenus() {
        let visionActions: [UIAction] = [
            UIAction(title: "Sem alterações", handler: { [weak self] _ in self?.visionPopupButton.setTitle("Sem alterações", for: .normal) }),
            UIAction(title: "Com déficit", handler: { [weak self] _ in self?.visionPopupButton.setTitle("Com déficit", for: .normal) }),
            UIAction(title: "Cegueira", handler: { [weak self] _ in self?.visionPopupButton.setTitle("Cegueira", for: .normal) })
        ]
        visionPopupButton.menu = UIMenu(children: visionActions)
        visionPopupButton.showsMenuAsPrimaryAction = true

        let hearingActions: [UIAction] = [
            UIAction(title: "Sem alterações", handler: { [weak self] _ in self?.hearingPopupButton.setTitle("Sem alterações", for: .normal) }),
            UIAction(title: "Com déficit", handler: { [weak self] _ in self?.hearingPopupButton.setTitle("Com déficit", for: .normal) }),
            UIAction(title: "Surdez", handler: { [weak self] _ in self?.hearingPopupButton.setTitle("Surdez", for: .normal) })
        ]
        hearingPopupButton.menu = UIMenu(children: hearingActions)
        hearingPopupButton.showsMenuAsPrimaryAction = true

        let locomotionActions: [UIAction] = [
            UIAction(title: "Sem auxílio", handler: { [weak self] _ in self?.locomotionPopupButton.setTitle("Sem auxílio", for: .normal) }),
            UIAction(title: "Bengala", handler: { [weak self] _ in self?.locomotionPopupButton.setTitle("Bengala", for: .normal) }),
            UIAction(title: "Andador", handler: { [weak self] _ in self?.locomotionPopupButton.setTitle("Andador", for: .normal) }),
            UIAction(title: "Cadeira de rodas", handler: { [weak self] _ in self?.locomotionPopupButton.setTitle("Cadeira de rodas", for: .normal) })
        ]
        locomotionPopupButton.menu = UIMenu(children: locomotionActions)
        locomotionPopupButton.showsMenuAsPrimaryAction = true
    }

    private func makeOralHealthOptionRow(text: String, isOn: Bool) -> UIView {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.blue40.cgColor
        button.tintColor = .white
        button.backgroundColor = isOn ? .blue40 : .clear
        button.setImage(
            UIImage(systemName: isOn ? "checkmark" : ""),
            for: .normal
        )
        button.setPreferredSymbolConfiguration(.init(pointSize: 14, weight: .bold), forImageIn: .normal)
        button.contentHorizontalAlignment = .center
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
            let isSelected = button.backgroundColor == .blue40
            button.backgroundColor = isSelected ? .clear : .blue40
            button.layer.borderColor = UIColor.blue40.cgColor
            button.tintColor = .white
            if isSelected {
                button.setImage(nil, for: .normal)
            } else {
                button.setImage(UIImage(systemName: "checkmark"), for: .normal)
            }
        }, for: .touchUpInside)

        return container
    }
}
