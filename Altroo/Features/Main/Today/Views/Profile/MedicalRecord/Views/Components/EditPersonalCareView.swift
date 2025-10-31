//
//  EditPersonalDataViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 28/10/25.
//

import UIKit

final class EditPersonalCareView: UIView {
    let viewModel: EditMedicalRecordViewModel
    weak var delegate: EditMedicalRecordViewControllerDelegate?

    private let header: EditSectionHeaderView = {
        let header = EditSectionHeaderView(
            sectionTitle: "Cuidados Pessoais",
            sectionDescription: "Preencha os campos a seguir quanto aos dados básicos da pessoa cuidada.",
            sectionIcon: "hand.raised.fill"
        )
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()

    private lazy var bathPopupMenuButton: PopupMenuButton = {
        let button = PopupMenuButton(title: "Com auxílio")
        button.backgroundColor = .blue40
        return button
    }()

    private lazy var hygienePopupMenuButton: PopupMenuButton = {
        let button = PopupMenuButton(title: "Sem auxílio")
        button.backgroundColor = .blue40
        return button
    }()

    private lazy var excretionPopupMenuButton: PopupMenuButton = {
        let button = PopupMenuButton(title: "Normal")
        button.backgroundColor = .blue40
        return button
    }()

    private lazy var feedingPopupMenuButton: PopupMenuButton = {
        let button = PopupMenuButton(title: "Comprometida")
        button.backgroundColor = .blue40
        return button
    }()

    private lazy var equipmentsTextField = StandardTextfield(placeholder: "Equipamentos separados por vírgulas")

    private lazy var bathSection = FormSectionView(title: "Banho", content: bathPopupMenuButton)
    private lazy var hygieneSection = FormSectionView(title: "Higiene", content: hygienePopupMenuButton)
    private lazy var excretionSection = FormSectionView(title: "Excreção", content: excretionPopupMenuButton)
    private lazy var feedingSection = FormSectionView(title: "Alimentação", content: feedingPopupMenuButton)
    private lazy var equipmentsSection = FormSectionView(title: "Equipamentos", content: equipmentsTextField)

    private lazy var firstRowStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [bathSection, hygieneSection])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .top
        stack.distribution = .fillEqually
        return stack
    }()

    private lazy var secondRowStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [excretionSection, feedingSection])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .top
        stack.distribution = .fillEqually
        return stack
    }()

    private lazy var formStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            firstRowStack,
            secondRowStack,
            equipmentsSection
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
        fillInformations()
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
        let bathActions: [UIAction] = [
            UIAction(title: "Sem auxílio", handler: { [weak self] _ in self?.bathPopupMenuButton.setTitle("Sem auxílio", for: .normal) }),
            UIAction(title: "Com auxílio", handler: { [weak self] _ in self?.bathPopupMenuButton.setTitle("Com auxílio", for: .normal) }),
            UIAction(title: "Dependente", handler: { [weak self] _ in self?.bathPopupMenuButton.setTitle("Dependente", for: .normal) })
        ]
        bathPopupMenuButton.menu = UIMenu(children: bathActions)
        bathPopupMenuButton.showsMenuAsPrimaryAction = true

        let hygieneActions: [UIAction] = [
            UIAction(title: "Sem auxílio", handler: { [weak self] _ in self?.hygienePopupMenuButton.setTitle("Sem auxílio", for: .normal) }),
            UIAction(title: "Com auxílio", handler: { [weak self] _ in self?.hygienePopupMenuButton.setTitle("Com auxílio", for: .normal) }),
            UIAction(title: "Dependente", handler: { [weak self] _ in self?.hygienePopupMenuButton.setTitle("Dependente", for: .normal) })
        ]
        hygienePopupMenuButton.menu = UIMenu(children: hygieneActions)
        hygienePopupMenuButton.showsMenuAsPrimaryAction = true

        let excretionActions: [UIAction] = [
            UIAction(title: "Normal", handler: { [weak self] _ in self?.excretionPopupMenuButton.setTitle("Normal", for: .normal) }),
            UIAction(title: "Incontinência", handler: { [weak self] _ in self?.excretionPopupMenuButton.setTitle("Incontinência", for: .normal) }),
            UIAction(title: "Constipação", handler: { [weak self] _ in self?.excretionPopupMenuButton.setTitle("Constipação", for: .normal) })
        ]
        excretionPopupMenuButton.menu = UIMenu(children: excretionActions)
        excretionPopupMenuButton.showsMenuAsPrimaryAction = true

        let feedingActions: [UIAction] = [
            UIAction(title: "Normal", handler: { [weak self] _ in self?.feedingPopupMenuButton.setTitle("Normal", for: .normal) }),
            UIAction(title: "Comprometida", handler: { [weak self] _ in self?.feedingPopupMenuButton.setTitle("Comprometida", for: .normal) }),
            UIAction(title: "Dependente", handler: { [weak self] _ in self?.feedingPopupMenuButton.setTitle("Dependente", for: .normal) })
        ]
        feedingPopupMenuButton.menu = UIMenu(children: feedingActions)
        feedingPopupMenuButton.showsMenuAsPrimaryAction = true
    }

    func fillInformations() {
        guard let patient = viewModel.userService.fetchCurrentPatient() else { return }
    }
}
