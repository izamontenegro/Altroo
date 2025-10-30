//
//  AssociatePatientViewController.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 30/09/25.
//

import UIKit

protocol AssociatePatientViewControllerDelegate: AnyObject {
    func goToPatientForms()
    func goToComorbiditiesForms()
    func goToShiftForms()
    func goToTutorialAddSheet()
    func goToMainFlow()
}

class AssociatePatientViewController: GradientHeader {
    weak var delegate: AssociatePatientViewControllerDelegate?
    private let viewModel: AssociatePatientViewModel
    
    private lazy var addNewPatientButton: CareRecipientCard = {
        let btn = CareRecipientCard(
            name: "Adicionar assistido",
            isPlusButton: true
        )
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapAddNewPatientButton))
        btn.addGestureRecognizer(tapGesture)
        btn.isUserInteractionEnabled = true
        
        return btn
    }()

    let addExistingPatientButton: UIButton = {
        let button = UIButton(type: .system)
        let label = StandardLabel(
            labelText: "Já tenho um assistido cadastrado",
            labelFont: .sfPro,
            labelType: .body,
            labelColor: .teal10,
            labelWeight: .medium
        )
        
        let image = UIImage(systemName: "info.circle")
        button.setImage(image, for: .normal)
        button.tintColor = label.labelColor
        
        button.setTitle(label.labelText, for: .normal)
        button.titleLabel?.font = label.font
        button.setTitleColor(label.textColor, for: .normal)
        
        button.semanticContentAttribute = .forceLeftToRight
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 4)
        
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.alwaysBounceVertical = true
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    let vStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = Layout.mediumSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    init(viewModel: AssociatePatientViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue80
        
        setNavbarItems(title: "Assistidos", subtitle: "Acompanhe os assistidos cadastrados no aplicativo ou adicione um novo.")

        setupLayout()
        updateView()
    }
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(vStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.mediumSpacing),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.mediumSpacing),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),

            vStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            vStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            vStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            vStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])

        addExistingPatientButton.addTarget(self, action: #selector(didTapAddExistingPatientButton), for: .touchUpInside)
    }

    private func updateView() {
        let careRecipients = viewModel.allPatients
        
        vStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
            for careRecipient in careRecipients {
                let card = CareRecipientCard(
                    name: careRecipient.personalData?.name ?? "",
                    careRecipient: careRecipient
                )
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCareRecipientCard(_:)))
                card.addGestureRecognizer(tapGesture)
                card.isUserInteractionEnabled = true
                
                vStack.addArrangedSubview(card)
            }
        
        vStack.addArrangedSubview(addNewPatientButton)
        vStack.setCustomSpacing(Layout.smallSpacing, after: addNewPatientButton)
        vStack.addArrangedSubview(addExistingPatientButton)

    }

    @objc private func didTapCareRecipientCard(_ sender: UITapGestureRecognizer) {
        guard let card = sender.view as? CareRecipientCard,
              let careRecipient = card.careRecipient else { return }
        
        viewModel.setCurrentPatient(careRecipient)
        delegate?.goToMainFlow()
    }
    
    @objc func didTapAddNewPatientButton() { delegate?.goToPatientForms() }
    
    @objc func didTapAddExistingPatientButton() { delegate?.goToTutorialAddSheet() }
}

//#Preview {
//    let mockService = UserServiceSession(context: AppDependencies().coreDataService.stack.context)
//    let viewModel = AssociatePatientViewModel(userService: mockService)
//    AssociatePatientViewController(viewModel: viewModel)
//}
