//
//  MyProfileViewController.swift
//  Altroo
//
//  Created by Marcelle Ribeiro Queiroz on 29/10/25.
//

import UIKit
import Combine

class MyProfileViewController: GradientNavBarViewController {

    private var cancellables = Set<AnyCancellable>()
    private let viewModel: MyProfileViewModel

    private var isEditingProfile: Bool = false
    private var nameEditField: StandardTextfield?

    // MARK: Container that acts as a "button" (receives touches)
    private let actionControl: UIControl = {
        let ctl = UIControl()
        ctl.translatesAutoresizingMaskIntoConstraints = false
        ctl.isUserInteractionEnabled = true
        return ctl
    }()
    // MARK: Current capsule view (actionControl subview)
    private var currentCapsule: CapsuleWithCircleView?

    init(viewModel: MyProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .pureWhite
        setupLayout()
        setupActions()
        updateActionCapsule()
        updateView()
        bindViewModel()
    }

    // MARK: - UI Components
    private let titleLabel: StandardLabel = {
        StandardLabel(
            labelText: "my_profile".localized,
            labelFont: .sfPro,
            labelType: .title2,
            labelColor: .black10,
            labelWeight: .semibold
        )
    }()
    private let subtitleLabel: StandardLabel = {
        let lbl = StandardLabel(
            labelText: "my_profile_subtitle".localized,
            labelFont: .sfPro,
            labelType: .body,
            labelColor: .black30,
            labelWeight: .regular
        )
        lbl.numberOfLines = 0
        return lbl
    }()

    lazy var vStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Layout
    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(actionControl)
        view.addSubview(vStack)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            actionControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            actionControl.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            actionControl.heightAnchor.constraint(equalToConstant: 36),
            actionControl.widthAnchor.constraint(greaterThanOrEqualToConstant: 88),

            vStack.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24),
            vStack.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
    }

    // MARK: - Actions
    private func setupActions() {
        actionControl.addTarget(self, action: #selector(actionControlTapped), for: .touchUpInside)
    }

    @objc private func actionControlTapped() {
        if isEditingProfile {
            saveChanges()
        } else {
            enterEditMode()
        }
    }

    // MARK: - Mode switches
    private func enterEditMode() {
        isEditingProfile = true
        updateActionCapsule()
        updateView()

        DispatchQueue.main.async { [weak self] in
            self?.nameEditField?.becomeFirstResponder()
        }
    }

    private func saveChanges() {
        guard let newName = nameEditField?.text?.trimmingCharacters(in: .whitespacesAndNewlines), !newName.isEmpty else {
            return
        }
        // MARK: Updates the viewModel
        viewModel.updateName(newName)

        isEditingProfile = false
        updateActionCapsule()
        updateView()
    }

    // MARK: - Recreate capsule view (sem depender de `update()` no capsule)
    private func updateActionCapsule() {
        currentCapsule?.removeFromSuperview()
        currentCapsule = nil

        let text = isEditingProfile ? "save".localized : "edit".localized
        let icon = isEditingProfile ? "checkmark" : "pencil"

        let capsule = CapsuleWithCircleView(
            capsuleColor: .teal20,
            text: text,
            textColor: .pureWhite,
            nameIcon: icon,
            nameIconColor: .teal20,
            circleIconColor: .pureWhite
        )
        capsule.translatesAutoresizingMaskIntoConstraints = false
        capsule.isUserInteractionEnabled = false

        actionControl.addSubview(capsule)
        currentCapsule = capsule

        NSLayoutConstraint.activate([
            capsule.leadingAnchor.constraint(equalTo: actionControl.leadingAnchor),
            capsule.trailingAnchor.constraint(equalTo: actionControl.trailingAnchor),
            capsule.topAnchor.constraint(equalTo: actionControl.topAnchor),
            capsule.bottomAnchor.constraint(equalTo: actionControl.bottomAnchor)
        ])

        actionControl.setNeedsLayout()
        actionControl.layoutIfNeeded()
    }

    // MARK: - Update central view
    private func updateView() {
        vStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        if isEditingProfile {
            let name = StandardLabel(labelText: "name".localized, labelFont: .sfPro, labelType: .body,
                                     labelColor: .black10, labelWeight: .medium)
            let tf = StandardTextfield(placeholder: viewModel.caregiverName)
            tf.text = viewModel.caregiverName
            tf.translatesAutoresizingMaskIntoConstraints = false
            nameEditField = tf
            
            vStack.addArrangedSubview(name)
            vStack.addArrangedSubview(tf)
            
            NSLayoutConstraint.activate([
                name.topAnchor.constraint(equalTo: vStack.topAnchor),
                name.leadingAnchor.constraint(equalTo: vStack.leadingAnchor),
                tf.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 16),
                tf.leadingAnchor.constraint(equalTo: vStack.leadingAnchor)
            ])
            
        } else {
            let nameRow = InfoRowView(title: "name".localized, info: viewModel.caregiverName)
            vStack.addArrangedSubview(nameRow)
            nameEditField = nil
        }
    }

    // MARK: - Bind viewModel
    private func bindViewModel() {
        viewModel.$caregiverName
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                if !self.isEditingProfile {
                    self.updateView()
                }
            }
            .store(in: &cancellables)
    }
}
