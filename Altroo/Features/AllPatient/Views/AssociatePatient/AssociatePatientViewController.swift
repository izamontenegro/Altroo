//
//  AssociatePatientViewController.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 30/09/25.
//

import UIKit
import Combine

protocol AssociatePatientViewControllerDelegate: AnyObject {
    func goToPatientForms()
    func goToComorbiditiesForms()
    func goToShiftForms(receivedPatientViaShare: Bool)
    func goToTutorialAddSheet()
    func goToMainFlow()
}

enum CareRecipientContext { case associatePatient, patientSelection }

class AssociatePatientViewController: GradientHeader {
    
    weak var delegate: AssociatePatientViewControllerDelegate?
    private let viewModel: AssociatePatientViewModel
    let context: CareRecipientContext

    private var cancellables = Set<AnyCancellable>()

    private lazy var addNewPatientButton: CareRecipientCard = {
        let btn = CareRecipientCard(
            name: "add_assisted".localized,
            isPlusButton: true
        )
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapAddNewPatientButton))
        btn.addGestureRecognizer(tapGesture)
        btn.isUserInteractionEnabled = true
        btn.enablePressEffect()
        
        return btn
    }()

    let addExistingPatientButton: UIButton = {
        let button = UIButton(type: .system)
        let label = StandardLabel(
            labelText: "already_have_assisted".localized,
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
        
        button.enableHighlightEffect()
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
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .teal10
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    init(viewModel: AssociatePatientViewModel, context: CareRecipientContext) {
        self.viewModel = viewModel
        self.context = context
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        setNavbarItems(title: "assisted".localized, subtitle: "assisted_subtitle".localized)

        super.viewDidLoad()
        view.backgroundColor = .blue80

        setupLayout()
        updateView()
        bindViewModel()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(remoteDataChanged),
            name: .didFinishCloudKitSync,
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        showTabBar(true)
    }

    //TODO: - Add loading view
    @objc private func remoteDataChanged() {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
            self.loadingIndicator.removeFromSuperview()
            self.viewModel.refreshData()
        }
    }

    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(vStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: gradientView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.mediumSpacing),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.mediumSpacing),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: context == .patientSelection ? -Layout.bigButtonBottomPadding : -20),

            vStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            vStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            vStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: context == .patientSelection ? -20 : 0),
            vStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])

        addExistingPatientButton.addTarget(self, action: #selector(didTapAddExistingPatientButton), for: .touchUpInside)
    }

    private func updateView() {
        let careRecipients = viewModel.fetchAvailableCareRecipients()
        
        vStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
            for careRecipient in careRecipients {
                let card = CareRecipientCard(
                    name: careRecipient.personalData?.name ?? "",
                    careRecipient: careRecipient,
                    currentCareRecipient: careRecipient == viewModel.getCurrentCareRecipient()
                )
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCareRecipientCard(_:)))
                card.addGestureRecognizer(tapGesture)
                card.isUserInteractionEnabled = true
                card.enablePressEffect()
                
                vStack.addArrangedSubview(card)
            }
        
        vStack.addArrangedSubview(addNewPatientButton)
        vStack.setCustomSpacing(Layout.smallSpacing, after: addNewPatientButton)
        vStack.addArrangedSubview(addExistingPatientButton)
    }
    
    @objc private func didTapCareRecipientCard(_ sender: UITapGestureRecognizer) {
        guard let card = sender.view as? CareRecipientCard,
              let careRecipient = card.careRecipient else { return }
        
        switch context {
        case .associatePatient:
            viewModel.setCurrentCareRecipient(careRecipient)
            delegate?.goToMainFlow()
        case .patientSelection:
            if viewModel.getCurrentCareRecipient() == careRecipient {
                delegate?.goToMainFlow()
            } else {
                viewModel.setCurrentCareRecipient(careRecipient)
            }
        }
    }
    
    private func bindViewModel() {
        viewModel.$careRecipients
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.updateView()
            }
            .store(in: &cancellables)
        
        viewModel.$currentCareRecipient
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.updateView()
            }
            .store(in: &cancellables)
    }
    
    @objc func didTapAddNewPatientButton() { delegate?.goToPatientForms() }
    
    @objc func didTapAddExistingPatientButton() { delegate?.goToTutorialAddSheet() }
}
