//
//  ProfileViewController.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 29/09/25.
//

import UIKit

protocol ProfileViewControllerDelegate: AnyObject {
    func openChangeCaregiversSheet()
    func openEditCaregiversSheet()
    func openShareCareRecipientSheet(_ careRecipient: CareRecipient)
    func goToMedicalRecordViewController()
}

final class CareRecipientProfileViewController: GradientNavBarViewController {
    weak var delegate: ProfileViewControllerDelegate?
    private(set) var mockPerson: CareRecipient!

    // MARK: - Lifecycle
    required init?(coder: NSCoder) { super.init(coder: coder) }
    init() { super.init(nibName: nil, bundle: nil) }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        createMockPerson()
        setupProfileHeader()
    }

    // MARK: - UI Setup
    private func setupProfileHeader() {
        let header = ProfileHeader(careRecipient: mockPerson)
        header.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(header)

        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        // torna o header clicável
        header.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapHeader))
        header.addGestureRecognizer(tap)

        setupCaregiversSection(below: header)
    }

    private func setupCaregiversSection(below header: UIView) {
        let titleLabel = StandardLabel(
            labelText: "Cuidadores",
            labelFont: .sfPro,
            labelType: .title2,
            labelColor: .black10,
            labelWeight: .semibold
        )

        let inviteButton = CapsuleIconView(iconName: "paperplane", text: "Convidar cuidador")
        addTap(to: inviteButton, action: #selector(didTapShareCareRecipientButton))

        let topStack = UIStackView(arrangedSubviews: [titleLabel, inviteButton])
        topStack.axis = .horizontal
        topStack.distribution = .equalSpacing
        topStack.alignment = .center
        topStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topStack)

        NSLayoutConstraint.activate([
            topStack.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 24),
            topStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            topStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        let caregivers = [1, 2, 3]
        let cardsStack = UIStackView()
        cardsStack.axis = .vertical
        cardsStack.spacing = 8
        cardsStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cardsStack)

        for _ in caregivers {
            let card = CaregiverProfileCardView()
            card.translatesAutoresizingMaskIntoConstraints = false
            card.heightAnchor.constraint(equalToConstant: 54).isActive = true
            cardsStack.addArrangedSubview(card)
        }

        NSLayoutConstraint.activate([
            cardsStack.topAnchor.constraint(equalTo: topStack.bottomAnchor, constant: 12),
            cardsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cardsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        setupBottomButtons(below: cardsStack)
    }

    private func setupBottomButtons(below lastView: UIView) {
        let swapButton = makeFilledButton(
            icon: UIImage(systemName: "arrow.triangle.2.circlepath"),
            title: "Trocar Perfil de Assistido",
            action: #selector(didTapChangeCareRecipientButton)
        )

        let endButton = makeOutlineButton(
            title: "Encerrar Cuidado",
            action: #selector(didTapEndCareButton)
        )

        let buttonsStack = UIStackView(arrangedSubviews: [swapButton, endButton])
        buttonsStack.axis = .vertical
        buttonsStack.spacing = 12
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsStack)

        NSLayoutConstraint.activate([
            buttonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonsStack.topAnchor.constraint(greaterThanOrEqualTo: lastView.bottomAnchor, constant: 24),
            buttonsStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    // MARK: - Botões customizados

    private func makeFilledButton(icon: UIImage?, title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.teal20
        button.layer.cornerRadius = 23
        button.heightAnchor.constraint(equalToConstant: 46).isActive = true
        button.addTarget(self, action: action, for: .touchUpInside)

        let label = StandardLabel(
            labelText: title,
            labelFont: .sfPro,
            labelType: .callOut,
            labelColor: .pureWhite,
            labelWeight: .medium
        )

        let iconView = UIImageView(image: icon)
        iconView.tintColor = .white
        iconView.contentMode = .scaleAspectFit
        iconView.setContentHuggingPriority(.required, for: .horizontal)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.widthAnchor.constraint(equalToConstant: 20).isActive = true

        let contentStack = UIStackView(arrangedSubviews: [iconView, label])
        contentStack.axis = .horizontal
        contentStack.alignment = .center
        contentStack.spacing = 8
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        button.addSubview(contentStack)
        NSLayoutConstraint.activate([
            contentStack.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            contentStack.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])

        return button
    }

    private func makeOutlineButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 23
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.teal10.cgColor
        button.heightAnchor.constraint(equalToConstant: 46).isActive = true
        button.addTarget(self, action: action, for: .touchUpInside)

        let label = StandardLabel(
            labelText: title,
            labelFont: .sfPro,
            labelType: .callOut,
            labelColor: .teal10,
            labelWeight: .medium
        )
        label.translatesAutoresizingMaskIntoConstraints = false

        button.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])

        return button
    }

    private func addTap(to view: UIView, action: Selector) {
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: action))
    }

    // MARK: - Actions
    @objc private func didTapHeader() { delegate?.goToMedicalRecordViewController() }
    @objc private func didTapChangeCareRecipientButton() { delegate?.openChangeCaregiversSheet() }
    @objc private func didTapShareCareRecipientButton() {
        guard let p = mockPerson else { return }
        delegate?.openShareCareRecipientSheet(p)
    }
    @objc private func didTapEndCareButton() { print("Encerrar cuidado") }
    @objc private func didTapEditCaregiverButton() { delegate?.openEditCaregiversSheet() }

    // MARK: - Mock
    private func createMockPerson() {
        let stack = CoreDataStack.shared
        let service = CoreDataService(stack: stack)
        let personalData = PersonalData(context: stack.context)
        personalData.name = "Raissa Parente"

        let recipient = CareRecipient(context: stack.context)
        recipient.personalData = personalData
        mockPerson = recipient

        service.save()
    }
}

#Preview {
    UINavigationController(rootViewController: CareRecipientProfileViewController())
}
