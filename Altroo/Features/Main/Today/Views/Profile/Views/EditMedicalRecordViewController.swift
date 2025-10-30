//
//  EditMedicalRecordViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 30/10/25.
//

import UIKit

final class EditMedicalRecordViewController: GradientNavBarViewController, MedicalRecordSectionSelectorViewDelegate {
    let viewModel: EditMedicalRecordViewModel
    weak var delegate: EditMedicalRecordViewControllerDelegate?
    
    private lazy var editPersonalDataView = EditPersonalDataView(viewModel: viewModel)
    private lazy var editPersonalCareView = EditPersonalCareView(viewModel: viewModel)

    private var currentContentView: UIView?

    private let contentContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var sectionSelectorView: MedicalRecordSectionSelectorView = {
        let selector = MedicalRecordSectionSelectorView(
            symbolNames: ["person.fill", "heart.fill", "figure.arms.open", "brain.head.profile.fill", "hand.raised.fill"]
        )
        selector.delegate = self
        return selector
    }()

    private let headerView: EditSectionHeaderView = {
        let header = EditSectionHeaderView(
            sectionTitle: "Prontuário",
            sectionDescription: "Selecione abaixo qual seção deseja editar sem sair desta tela.",
            sectionIcon: "doc.text.fill"
        )
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()

    init(viewModel: EditMedicalRecordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .pureWhite

        view.addSubview(sectionSelectorView)
        view.addSubview(contentContainerView)

        NSLayoutConstraint.activate([
            sectionSelectorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            sectionSelectorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            sectionSelectorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            contentContainerView.topAnchor.constraint(equalTo: sectionSelectorView.bottomAnchor, constant: 20),
            contentContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        displaySection(editPersonalDataView)
    }

    private func setupLayout() {
        view.addSubview(headerView)
        view.addSubview(contentContainerView)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            contentContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func medicalRecordSectionSelectorView(_ selectorView: MedicalRecordSectionSelectorView, didSelectIndex index: Int) {
        switch index {
        case 0: displaySection(editPersonalDataView)
        case 1: displaySection(editPersonalCareView)
        case 2: displaySection(editPersonalCareView)
        case 3: displaySection(editPersonalCareView)
        case 4: displaySection(editPersonalCareView)
        default: displaySection(editPersonalDataView)
        }
    }

    private func displaySection(_ newContentView: UIView) {
        if let currentContentView {
            currentContentView.removeFromSuperview()
        }

        contentContainerView.addSubview(newContentView)
        newContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newContentView.topAnchor.constraint(equalTo: contentContainerView.topAnchor),
            newContentView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor),
            newContentView.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor),
            newContentView.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor)
        ])

        currentContentView = newContentView
        view.layoutIfNeeded()
    }
}
