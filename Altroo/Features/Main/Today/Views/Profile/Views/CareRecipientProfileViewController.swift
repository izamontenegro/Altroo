//
//  ProfileViewController.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 29/09/25.
//

import UIKit
import CloudKit
import Combine

protocol ProfileViewControllerDelegate: AnyObject {
    func openShareCareRecipientSheet(_ careRecipient: CareRecipient)
    func goToMedicalRecordViewController()
    func goToAllPatient() async
}

final class CareRecipientProfileViewController: GradientNavBarViewController {
    weak var delegate: ProfileViewControllerDelegate?
    let viewModel: CareRecipientProfileViewModel
    var goToEdit: Bool = false
    
    var emergencyContact: ContactDisplayItem?
    var copyTarget: AnyObject?
    var copyAction: Selector?
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    init(viewModel: CareRecipientProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Use init(viewModel:) instead of init(coder:)")
    }
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        goToEdit = false
        viewModel.buildData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.buildData()
        setupUI()
        bindViewModel()
    }
    
    // MARK: - View Layout
    private func setupUI() {
    
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        
        let content = UIStackView()
        content.axis = .vertical
        content.alignment = .fill
        content.spacing = 16
        content.translatesAutoresizingMaskIntoConstraints = false
            
        scrollView.addSubview(content)
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 24),
            content.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            content.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            content.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -24)
        ])
        
        let headerSection = setupProfileHeader()
        let emergencySection = setupEmergencyContactSection()
//        let aboutYouSection = setupAboutYouSection()
        let permissionsSection = setupCaregiversSection()
        let button = setupBottomButtons()
        
        content.addArrangedSubview(headerSection)
        content.addArrangedSubview(emergencySection)
//        content.addArrangedSubview(aboutYouSection)
        content.addArrangedSubview(permissionsSection)
        content.addArrangedSubview(button)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//
//            content.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 24),
//            content.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
//            content.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
//            content.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -24)
        ])
    }
    
    // MARK: - ASSISTED CARD
    private func setupProfileHeader() -> UIView {
        view.backgroundColor = .pureWhite
        
//        view.subviews.forEach { $0.removeFromSuperview() }
        
        guard let person = viewModel.currentCareRecipient else {
            let empty = StandardLabel(
                labelText: "Nenhum assistido selecionado",
                labelFont: .sfPro,
                labelType: .body,
                labelColor: .black20,
                labelWeight: .regular
            )
            empty.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(empty)
            
            NSLayoutConstraint.activate([
                empty.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                empty.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
            
            return empty
        }
        
        // MARK: - ASSISTED CARD
        let header = ProfileHeader(careRecipient: person, percent: viewModel.completionPercent)
        header.translatesAutoresizingMaskIntoConstraints = false
        
        let updatedLabel = StandardLabel(
            labelText: "Última atualização em: ",
            labelFont: .sfPro,
            labelType: .subHeadline,
            labelColor: .black30,
            labelWeight: .medium
        )
        
        let updatedLabelDate = StandardLabel(
            labelText: viewModel.getUpdatedAt(),
            labelFont: .sfPro,
            labelType: .subHeadline,
            labelColor: .black30,
            labelWeight: .regular
        )
        
        let updatedStack = UIStackView()
        updatedStack.axis = .horizontal
        updatedStack.spacing = 0
        updatedStack.addArrangedSubview(updatedLabel)
        updatedStack.addArrangedSubview(updatedLabelDate)
        updatedStack.translatesAutoresizingMaskIntoConstraints = false
        
        header.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapHeader))
        header.addGestureRecognizer(tap)
        header.enableHighlightEffect()
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        
        stack.addArrangedSubview(header)
        stack.addArrangedSubview(updatedStack)

        
        return stack
    }
    // MARK: - EMERGENCY CONTACT
    private func setupEmergencyContactSection() -> UIView {
        guard let contact = viewModel.getContactDisplayItem() else {
            return UIView()
        }
        
        let contactTitleLabel = StandardLabel(
            labelText: "Contato de Emergência",
            labelFont: .sfPro,
            labelType: .title2,
            labelColor: .black10,
            labelWeight: .semibold
        )
        contactTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let contactCard = ContactCardView(
            name: contact.name,
            relation: contact.relationship,
            phone: contact.phone,
            copyTarget: copyTarget,
            copyAction: copyAction ?? #selector(UIView.didMoveToSuperview)
        )
        contactCard.translatesAutoresizingMaskIntoConstraints = false
        
        let emergencyContactView = UIStackView(arrangedSubviews: [contactTitleLabel, contactCard])
        emergencyContactView.axis = .vertical
        emergencyContactView.spacing = 8
        emergencyContactView.translatesAutoresizingMaskIntoConstraints = false
        
        return emergencyContactView
    }
    // MARK: - ABOUT YOU
//    private func setupAboutYouSection() -> UIView {
//        let titleLabel = StandardLabel(
//            labelText: "Sobre você",
//            labelFont: .sfPro,
//            labelType: .title2,
//            labelColor: .black10,
//            labelWeight: .semibold
//        )
//        let editButton = CapsuleWithCircleView(
//            capsuleColor: .teal20, text: "edit".localized,
//            textColor: .pureWhite, nameIcon: "pencil",
//            nameIconColor: .teal20, circleIconColor: .pureWhite
//        )
//        editButton.enablePressEffect()
//        
//        //        let shiftRow = InfoRowView(title: "Turno", info: viewModel.)
//        //        let relationshipRow = InfoRowView(title: "Relação", info: viewModel.)
//        
//        let horizontalStack = UIStackView(arrangedSubviews: [titleLabel, editButton])
//        horizontalStack.axis = .horizontal
//        horizontalStack.distribution = .equalSpacing
//        horizontalStack.alignment = .leading
//        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
//        
////        let rowsStack = UIStackView(arrangedSubviews: [shiftRow, relationshipRow])
////        rowsStack.axis = .vertical
////        rowsStack.spacing = 8
////        rowsStack.alignment = .leading
////        rowsStack.translatesAutoresizingMaskIntoConstraints = false
////        view.addSubview(rowsStack)
////        
////        let aboutYouView = UIStackView(arrangedSubviews: [horizontalStack, rowsStack])
////        aboutYouView.axis = .vertical
////        aboutYouView.spacing = 16
////        aboutYouView.translatesAutoresizingMaskIntoConstraints = false
////        view.addSubview(aboutYouView)
//        
////        NSLayoutConstraint.activate([
////            aboutYouView.topAnchor.constraint(equalTo: emergencyContactView.bottomAnchor, constant: 16),
////            aboutYouView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
////            aboutYouView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
////        ])
//        
//    }
    // MARK: - PERMISSIONS
    private func setupCaregiversSection() -> UIView {
        let caregivers = viewModel.caregiversFor(recipient: viewModel.currentCareRecipient)
        let uniqueCaregivers = caregivers.unique { $0.name }
        
        let titleLabel = StandardLabel(
            labelText: "permissions".localized,
            labelFont: .sfPro,
            labelType: .title2,
            labelColor: .black10,
            labelWeight: .semibold
        )
        let inviteButton = CapsuleWithCircleView(
            capsuleColor: .teal20, text: "invite_caregiver".localized,
            textColor: .pureWhite, nameIcon: "paperplane",
            nameIconColor: .teal20, circleIconColor: .pureWhite
        )
        
        inviteButton.enablePressEffect()
        inviteButton.onTap = { [weak self] in
            guard let self = self else { return }
            
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.translatesAutoresizingMaskIntoConstraints = false
            spinner.startAnimating()
            
            let wrapper = UIView()
            wrapper.translatesAutoresizingMaskIntoConstraints = false
            wrapper.addSubview(spinner)
            
            NSLayoutConstraint.activate([
                spinner.centerXAnchor.constraint(equalTo: wrapper.centerXAnchor, constant: -20),
                spinner.centerYAnchor.constraint(equalTo: wrapper.centerYAnchor)
            ])
            
            if let stack = inviteButton.superview as? UIStackView,
               let index = stack.arrangedSubviews.firstIndex(of: inviteButton) {
                inviteButton.isHidden = true
                stack.insertArrangedSubview(wrapper, at: index)
            }
            self.didTapShareCareRecipientButton()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                wrapper.removeFromSuperview()
                inviteButton.isHidden = false
            }
        }
        
        guard let careRecipient = viewModel.userService.fetchCurrentPatient() else { return UIView()}
        let isOwner = viewModel.coreDataService.isOwner(object: careRecipient)
        inviteButton.isHidden = !(uniqueCaregivers.isEmpty || isOwner)
        
        let topStack = UIStackView(arrangedSubviews: [titleLabel, inviteButton])
        topStack.axis = .horizontal
        topStack.distribution = .equalSpacing
        topStack.translatesAutoresizingMaskIntoConstraints = false
        
        let cardsStack = UIStackView()
        cardsStack.axis = .vertical
        cardsStack.spacing = 8
        cardsStack.translatesAutoresizingMaskIntoConstraints = false
        
        let caregiverSection = UIStackView(arrangedSubviews: [topStack, cardsStack])
        caregiverSection.axis = .vertical
        caregiverSection.spacing = 16
        caregiverSection.translatesAutoresizingMaskIntoConstraints = false
        
        if uniqueCaregivers.count <= 1 {
            let card = CaregiverProfileCardView(
                coreDataService: viewModel.coreDataService,
                name: "you".localized,
                category: viewModel.userService.fetchUser()?.category ?? "caregiver".localized,
                permission: .readWrite,
                isOwner: true
            )
            
            card.translatesAutoresizingMaskIntoConstraints = false
            card.heightAnchor.constraint(equalToConstant: 54).isActive = true
            cardsStack.addArrangedSubview(card)
        } else {
            for item in uniqueCaregivers {
                guard let careRecipient = viewModel.userService.fetchCurrentPatient() else { continue }
                let participants = viewModel.coreDataService.fetchParticipants(for: careRecipient) ?? []
                guard let participant = participants.first(where: {
                    viewModel.coreDataService.matches($0, with: item, in: careRecipient)
                }) else { continue }
                
                let card = CaregiverProfileCardView(
                    coreDataService: viewModel.coreDataService,
                    participant: participant,
                    parentObject: careRecipient,
                    name: item.name.abbreviatedName,
                    category: item.category,
                    permission: participant.permission,
                    isOwner: viewModel.coreDataService.isOwner(object: careRecipient)
                )
                
                card.translatesAutoresizingMaskIntoConstraints = false
                card.heightAnchor.constraint(equalToConstant: 54).isActive = true
                cardsStack.addArrangedSubview(card)
            }
        }
        
        return caregiverSection
    }
    // MARK: - BUTTON END FOLLOW UP
    private func setupBottomButtons() -> UIView {
        let endButton = makeOutlineButton(
            title: "end_follow_up".localized,
            action: #selector(didTapEndCareButton)
        )
        endButton.enablePressAnimation()
        
        return endButton
    }
    
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
        button.layer.borderWidth = 3
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
    
    private func bindViewModel() {
        Publishers.CombineLatest(
            viewModel.$currentCareRecipient,
            viewModel.$completionPercent
        )
        .receive(on: RunLoop.main)
        .sink { [weak self] _, _ in
//            self?.setupUI()
        }
        .store(in: &cancellables)
        
        viewModel.$caregivers
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
//                self?.setupUI()
            }
            .store(in: &cancellables)
    }
    
    private func addTap(to view: UIView, action: Selector) {
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: action))
    }
    
    @objc private func didTapHeader() {
        goToEdit = true
        delegate?.goToMedicalRecordViewController()
    }
    
    @objc private func didTapShareCareRecipientButton() {
        guard let careRecipient = viewModel.currentCareRecipient else { return }
        delegate?.openShareCareRecipientSheet(careRecipient)
    }
    
    @objc private func didTapEndCareButton() {
        let alertController = UIAlertController(
            title: "Deseja encerrar o acompanhamento de \(viewModel.getCurrentCareRecipientName())?",
            message: "Você precisará ser convidado novamente para ter acesso aos dados do paciente.",
            preferredStyle: .alert
        )
        
        let confirmAction = UIAlertAction(title: "Encerrar", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.finishCare()
            
            Task {
                await self.delegate?.goToAllPatient()
            }
        }
        
        let cancelAction = UIAlertAction(title: "cancel".localized, style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
