//
//  MedicalRecordViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 11/10/25.
//

import UIKit
import Combine

protocol EditMedicalRecordViewControllerDelegate: AnyObject {
    func goToPersonalData()
    func goToMentalState()
    func goToPersonalCare()
    func goToPhysicalState()
    func goToHealthProblems()
}

final class MedicalRecordViewController: GradientNavBarViewController {
    let viewModel: MedicalRecordViewModel
    weak var delegate: EditMedicalRecordViewControllerDelegate?
    private var cancellables = Set<AnyCancellable>()
    private var toastLabel: UILabel?
    private let scrollViewTag = 7001
    private let contentStackTag = 7002
    
    init(viewModel: MedicalRecordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.reload()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        bindViewModel()
    }

    private func bindViewModel() {
        viewModel.$sections
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.reloadContent()
            }
            .store(in: &cancellables)
    }

    private func setupLayout() {
        view.backgroundColor = .pureWhite
        
        let scrollView = UIScrollView()
        scrollView.tag = scrollViewTag
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        let contentStack = UIStackView()
        contentStack.tag = contentStackTag
        contentStack.axis = .vertical
        contentStack.spacing = 24
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30),
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -40),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        reloadContent()
    }
    
    private func resolveContentStack() -> UIStackView? {
        view.viewWithTag(contentStackTag) as? UIStackView
    }

    private func reloadContent() {
        guard let contentStack = resolveContentStack() else { return }
        contentStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        contentStack.addArrangedSubview(makeHeaderSection(percent: viewModel.completionPercent))
        contentStack.addArrangedSubview(makeCompletionAlertAndButton())

        for section in viewModel.sections {
            contentStack.addArrangedSubview(makeSection(
                title: section.title,
                rows: section.rows,
                icon: section.iconSystemName
            ))
        }
    }

    func makeHeaderSection(percent: CGFloat) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        
        let titleLabel = StandardLabel(
            labelText: "Ficha Médica",
            labelFont: .sfPro,
            labelType: .title2,
            labelColor: .black10,
            labelWeight: .semibold
        )
        
        let subtitleLabel = StandardLabel(
            labelText: "Reúna as informações de saúde do assistido em um só lugar, de forma simples e acessível.",
            labelFont: .sfPro,
            labelType: .body,
            labelColor: .black30,
            labelWeight: .regular
        )
        subtitleLabel.numberOfLines = 0
        
        let progressBar = MedicalRecordProgressBarView(
            height: 15,
            cornerRadius: 8,
            trackColor: .blue80,
            startColor: .blue10,
            endColor: .blue50,
            progress: percent
        )
        
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        
        let percentLabel = StandardLabel(
            labelText: "\(Int(round(percent * 100)))%",
            labelFont: .sfPro,
            labelType: .callOut,
            labelColor: .blue20,
            labelWeight: .medium
        )
        percentLabel.setContentHuggingPriority(.required, for: .horizontal)
        percentLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        let progressRow = UIStackView(arrangedSubviews: [progressBar, percentLabel])
        progressRow.axis = .horizontal
        progressRow.alignment = .center
        progressRow.spacing = 10
        
        let headerStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, progressRow])
        headerStack.axis = .vertical
        headerStack.spacing = 4
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(headerStack)
        
        NSLayoutConstraint.activate([
            progressBar.trailingAnchor.constraint(equalTo: percentLabel.leadingAnchor, constant: -10),
            progressBar.widthAnchor.constraint(greaterThanOrEqualToConstant: 110),
            
            headerStack.topAnchor.constraint(equalTo: containerView.topAnchor),
            headerStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            headerStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            headerStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        return containerView
    }
    
    private func makeCompletionAlertAndButton() -> UIView {
        let wrapperStack = UIStackView()
        wrapperStack.axis = .vertical
        wrapperStack.spacing = -15
        wrapperStack.translatesAutoresizingMaskIntoConstraints = false

        let alertBoxView = UIView()
        alertBoxView.backgroundColor = UIColor.teal80
        alertBoxView.layer.cornerRadius = 5

        let alertIconView = UIImageView(image: UIImage(systemName: "exclamationmark.triangle.fill"))
        alertIconView.tintColor = .teal10
        alertIconView.translatesAutoresizingMaskIntoConstraints = false
        alertIconView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        alertIconView.heightAnchor.constraint(equalToConstant: 36).isActive = true

        let alertLabel = StandardLabel(
            labelText: "Finalize o preenchimento para ter os dados de saúde do paciente à mão quando precisar.",
            labelFont: .sfPro,
            labelType: .subHeadline,
            labelColor: .teal10,
            labelWeight: .regular
        )
        alertLabel.numberOfLines = 0

        let alertStack = UIStackView(arrangedSubviews: [alertIconView, alertLabel])
        alertStack.axis = .horizontal
        alertStack.alignment = .center
        alertStack.spacing = 10
        alertStack.translatesAutoresizingMaskIntoConstraints = false

        alertBoxView.addSubview(alertStack)
        NSLayoutConstraint.activate([
            alertStack.topAnchor.constraint(equalTo: alertBoxView.topAnchor, constant: 8),
            alertStack.bottomAnchor.constraint(equalTo: alertBoxView.bottomAnchor, constant: -23),
            alertStack.leadingAnchor.constraint(equalTo: alertBoxView.leadingAnchor, constant: 8),
            alertStack.trailingAnchor.constraint(equalTo: alertBoxView.trailingAnchor, constant: -8)
        ])

        let editButton = LargeFilledButton(
            title: "Editar Ficha Médica",
            icon: UIImage(systemName: "square.and.pencil")
        )

        wrapperStack.addArrangedSubview(alertBoxView)
        wrapperStack.addArrangedSubview(editButton)
        
        editButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapEditButton))
        editButton.addGestureRecognizer(tapGesture)
        
        return wrapperStack
    }

    private func makeSection(title: String, rows: [InfoRow], icon: String) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .clear

        let headerView = makeSectionHeader(title: title, icon: icon)

        let itemsStack = UIStackView()
        itemsStack.axis = .vertical
        itemsStack.spacing = 10
        itemsStack.translatesAutoresizingMaskIntoConstraints = false
       
        let titleLabel = StandardLabel(
            labelText: title,
            labelFont: .sfPro,
            labelType: .body,
            labelColor: .blue20,
            labelWeight: .regular
        )
        
        if rows[0].title == "Cirurgias" || rows[0].title == "Contatos" {
            let verticalStack = UIStackView()
            verticalStack.axis = .vertical
            verticalStack.spacing = 4
            verticalStack.translatesAutoresizingMaskIntoConstraints = false
            
            verticalStack.addArrangedSubview(titleLabel)
            verticalStack.addArrangedSubview(itemsStack)
        }

        for row in rows {
            if row.title == "Cirurgias", row.value.isEmpty {
                for surgeryInfo in viewModel.surgeryDisplayItems {
                    let itemView = MedicalRecordInfoItemView(
                        infotitle: "",
                        primaryText: surgeryInfo.primary,
                        secondaryText: surgeryInfo.secondary
                    )
                    itemView.translatesAutoresizingMaskIntoConstraints = false
                    itemsStack.addArrangedSubview(itemView)
                }
            } else if row.title == "Contatos", row.value.isEmpty {
                for contactItem in viewModel.contactDisplayItems {
                    let contactView = ContactCardView(
                        name: contactItem.name,
                        relation: contactItem.relation,
                        phone: contactItem.phone,
                        copyTarget: self,
                        copyAction: #selector(didTapCopyPhoneButton(_:))
                    )
                    itemsStack.addArrangedSubview(contactView)
                }
            } else {
                let itemView = MedicalRecordInfoItemView(
                    infotitle: row.title,
                    infoDescription: row.value
                )
                itemView.translatesAutoresizingMaskIntoConstraints = false
                itemsStack.addArrangedSubview(itemView)
            }
        }

        containerView.addSubview(headerView)
        containerView.addSubview(itemsStack)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 36),

            itemsStack.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8),
            itemsStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            itemsStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            itemsStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])

        return containerView
    }

    private func makeSectionHeader(title: String, icon: String) -> UIView {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.blue30
        headerView.layer.cornerRadius = 4
        headerView.translatesAutoresizingMaskIntoConstraints = false

        let iconImageView = UIImageView(image: UIImage(systemName: icon))
        iconImageView.tintColor = .pureWhite
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 19).isActive = true

        let titleLabel = StandardLabel(
            labelText: title,
            labelFont: .sfPro,
            labelType: .body,
            labelColor: .pureWhite,
            labelWeight: .semibold
        )

        let titleStack = UIStackView(arrangedSubviews: [iconImageView, titleLabel])
        titleStack.axis = .horizontal
        titleStack.spacing = 8
        titleStack.translatesAutoresizingMaskIntoConstraints = false

        headerView.addSubview(titleStack)
        NSLayoutConstraint.activate([
            titleStack.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 12),
            titleStack.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])

        return headerView
    }

    private func showCopiedToast(with message: String) {
        if toastLabel == nil {
            let label = UILabel()
            label.backgroundColor = UIColor.black10.withAlphaComponent(0.75)
            label.textColor = .white
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            label.layer.cornerRadius = 14
            label.layer.masksToBounds = true
            label.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label)
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                label.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                label.heightAnchor.constraint(greaterThanOrEqualToConstant: 28)
            ])
            toastLabel = label
        }
        toastLabel?.text = "  \(message)  "
        
        UIView.animate(withDuration: 0.18, animations: {
            self.toastLabel?.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.25, delay: 1.2, options: [], animations: {
                self.toastLabel?.alpha = 0.0
            }, completion: nil)
        }
    }
    
    @objc private func didTapCopyPhoneButton(_ sender: UIButton) {
        let valueToCopy = sender.accessibilityValue ?? ""
        UIPasteboard.general.string = valueToCopy

        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()

        showCopiedToast(with: "Número copiado")
    }
    
    @objc func didTapEditButton() {
        delegate?.goToPersonalData()
    }
}
