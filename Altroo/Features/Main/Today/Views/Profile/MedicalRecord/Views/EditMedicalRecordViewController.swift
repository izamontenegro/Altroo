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
    
    private lazy var editPersonalDataForms = EditPersonalDataView(viewModel: viewModel)
    private lazy var editHealthProblemsForms = EditHealthProblemsView(viewModel: viewModel)
    private lazy var editPhysicalStateForms = EditPhysicalStateView(viewModel: viewModel)
    private lazy var editMentalStateForms = EditMentalStateView(viewModel: viewModel)
    private lazy var editPersonalCareForms = EditPersonalCareView(viewModel: viewModel)

    private var currentContentView: UIView?

    private let contentContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(viewModel: EditMedicalRecordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private lazy var sectionSelectorView: MedicalRecordSectionSelectorView = {
        let selector = MedicalRecordSectionSelectorView(
            symbolNames: ["person.fill", "heart.fill", "figure.arms.open", "brain.head.profile.fill", "hand.raised.fill"]
        )
        selector.delegate = self
        selector.translatesAutoresizingMaskIntoConstraints = false

        return selector
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .pureWhite

        view.addSubview(sectionSelectorView)
        view.addSubview(contentContainerView)

        NSLayoutConstraint.activate([
            contentContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            contentContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            sectionSelectorView.heightAnchor.constraint(equalToConstant: 30),

            sectionSelectorView.topAnchor.constraint(equalTo: contentContainerView.bottomAnchor, constant: 10),
            sectionSelectorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sectionSelectorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sectionSelectorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        view.bringSubviewToFront(sectionSelectorView)

        displaySection(editPersonalDataForms)
    }
    
    private func setupLayout() {
        view.addSubview(contentContainerView)

        NSLayoutConstraint.activate([
            contentContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func medicalRecordSectionSelectorView(_ selectorView: MedicalRecordSectionSelectorView, didSelectIndex index: Int) {
        switch index {
        case 0: displaySection(editPersonalDataForms)
        case 1: displaySection(editHealthProblemsForms)
        case 2: displaySection(editPhysicalStateForms)
        case 3: displaySection(editMentalStateForms)
        case 4: displaySection(editPersonalCareForms)
        default: displaySection(editPersonalDataForms)
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
