//
//  ProfileViewController.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 29/09/25.
//

import UIKit
import CloudKit

protocol ProfileViewControllerDelegate: AnyObject {
    func openChangeCareRecipientSheet()
    func openShareCareRecipientSheet(_ careRecipient: CareRecipient)
    func goToMedicalRecordViewController()
    func careRecipientProfileWantsChangeAssociate(_ controller: UIViewController)
}

final class CareRecipientProfileViewController: GradientNavBarViewController {
    weak var delegate: ProfileViewControllerDelegate?
    let viewModel: CareRecipientProfileViewModel
    var goToEdit: Bool = false
    
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
        viewModel.buildData()
        NotificationCenter.default.post(name: .toggleTabBarVisibility, object: nil, userInfo: ["hidden": true])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if goToEdit {
            
        } else {
            NotificationCenter.default.post(name: .toggleTabBarVisibility, object: nil, userInfo: ["hidden": false])
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.buildData()
        setupProfileHeader()
    }
    
    private func setupProfileHeader() {
        view.backgroundColor = .pureWhite
        
        view.subviews.forEach { $0.removeFromSuperview() }
        
        guard let person = viewModel.currentCareRecipient() else {
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
            return
        }
        
        let header = ProfileHeader(careRecipient: person, percent: viewModel.completionPercent)
        header.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(header)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
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
        
        let caregivers = viewModel.caregiversForCurrentRecipient()
        
        let cardsStack = UIStackView()
        cardsStack.axis = .vertical
        cardsStack.spacing = 8
        cardsStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cardsStack)
        
        if caregivers.isEmpty {
            let none = StandardLabel(
                labelText: "Nenhum cuidador ainda. Toque em “Convidar cuidador”.",
                labelFont: .sfPro,
                labelType: .footnote,
                labelColor: .black20,
                labelWeight: .regular
            )
            cardsStack.addArrangedSubview(none)
        } else {
            for item in caregivers {
                print("Nome: \(item.name) | Categoria: \(item.category) | Permissão: \(item.permission.rawValue)")
                
                let card = CaregiverProfileCardView(
                    name: item.name,
                    category: item.category,
                    permission: item.permission
                )
                card.translatesAutoresizingMaskIntoConstraints = false
                card.heightAnchor.constraint(equalToConstant: 54).isActive = true
                cardsStack.addArrangedSubview(card)
            }
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
            icon: UIImage(systemName: "arrow.2.squarepath"),
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
    
    @objc private func didTapHeader() {
        goToEdit = true
        NotificationCenter.default.post(name: .toggleTabBarVisibility, object: nil, userInfo: ["hidden": true])
        delegate?.goToMedicalRecordViewController()
    }
    @objc private func didTapChangeCareRecipientButton() { delegate?.openChangeCareRecipientSheet() }
    @objc private func didTapShareCareRecipientButton() {
        guard let careRecipient = viewModel.currentCareRecipient() else { return }
        delegate?.openShareCareRecipientSheet(careRecipient)
    }
    
    @objc private func didTapEndCareButton() {
        let alertController = UIAlertController(
            title: "Tem certeza?",
            message: "Essa ação é irreversível.",
            preferredStyle: .alert
        )
        
        let confirmAction = UIAlertAction(title: "Encerrar", style: .destructive) { [weak self] _ in
            guard let self = self else { return } 
            self.viewModel.finishCare()
            self.delegate?.careRecipientProfileWantsChangeAssociate(self)
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        present(alertController, animated: true, completion: nil)
    }
    //    @objc private func didTapEditCaregiverButton() { delegate?.openEditCaregiversSheet() }
}
//
//#Preview {
//    UINavigationController(rootViewController: CareRecipientProfileViewController()
//}
