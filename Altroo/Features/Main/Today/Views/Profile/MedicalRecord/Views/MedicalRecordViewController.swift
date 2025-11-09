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

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    private func setupLayout() {
        view.backgroundColor = .pureWhite

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

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

    private func reloadContent() {
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
        
        let trackView = UIView()
        trackView.translatesAutoresizingMaskIntoConstraints = false
        trackView.backgroundColor = .blue80
        trackView.layer.cornerRadius = 8
        
        let fillView = UIView()
        fillView.translatesAutoresizingMaskIntoConstraints = false
        fillView.layer.cornerRadius = 8
        fillView.clipsToBounds = true
        fillView.backgroundColor = .blue10
        
        trackView.addSubview(fillView)
        
        let percentLabel = StandardLabel(
            labelText: "\(Int(round(percent * 100)))%",
            labelFont: .sfPro,
            labelType: .callOut,
            labelColor: .blue20,
            labelWeight: .medium
        )
        percentLabel.setContentHuggingPriority(.required, for: .horizontal)
        percentLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        let progressRow = UIStackView(arrangedSubviews: [trackView, percentLabel])
        progressRow.axis = .horizontal
        progressRow.alignment = .center
        progressRow.spacing = 10
        
        let headerStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, progressRow])
        headerStack.axis = .vertical
        headerStack.spacing = 4
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(headerStack)
        
        NSLayoutConstraint.activate([
            trackView.trailingAnchor.constraint(equalTo: percentLabel.leadingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            trackView.heightAnchor.constraint(equalToConstant: 15),
            trackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 110),
            
            fillView.leadingAnchor.constraint(equalTo: trackView.leadingAnchor),
            fillView.centerYAnchor.constraint(equalTo: trackView.centerYAnchor),
            fillView.heightAnchor.constraint(equalTo: trackView.heightAnchor),
            fillView.widthAnchor.constraint(equalTo: trackView.widthAnchor, multiplier: max(0, min(1, percent))),
            
            headerStack.topAnchor.constraint(equalTo: containerView.topAnchor),
            headerStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            headerStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            headerStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        DispatchQueue.main.async {
            containerView.layoutIfNeeded()
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [UIColor.blue10.cgColor, UIColor.blue50.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint =   CGPoint(x: 1.0, y: 0.5)
            gradientLayer.frame = fillView.bounds
            gradientLayer.cornerRadius = fillView.layer.cornerRadius
            fillView.layer.insertSublayer(gradientLayer, at: 0)
        }
        
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

        let editButton = makeFilledButton(
            icon: UIImage(systemName: "square.and.pencil"),
            title: "Editar Ficha Médica"
        )

        wrapperStack.addArrangedSubview(alertBoxView)
        wrapperStack.addArrangedSubview(editButton)
        
        editButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapEditButton))
        editButton.addGestureRecognizer(tapGesture)
        
        return wrapperStack
    }

    // MARK: - Section
    private func makeSection(title: String, rows: [InfoRow], icon: String) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .clear

        let headerView = makeSectionHeader(title: title, icon: icon)

        let itemsStack = UIStackView()
        itemsStack.axis = .vertical
        itemsStack.spacing = 10
        itemsStack.translatesAutoresizingMaskIntoConstraints = false

        for row in rows {
            if row.title == "Cirurgias", row.value.isEmpty {
                for surgeryInfo in viewModel.surgeryDisplayItems {
                    let itemView = MedicalRecordInfoItemView(
                        infotitle: surgeryInfo.title,
                        primaryText: surgeryInfo.primary,
                        secondaryText: surgeryInfo.secondary
                    )
                    itemView.translatesAutoresizingMaskIntoConstraints = false
                    itemsStack.addArrangedSubview(itemView)
                }
            } else if row.title == "Contatos", row.value.isEmpty {
                for contactItem in viewModel.contactDisplayItems {
                    let contactView = makeContactCard(
                        name: contactItem.name,
                        relation: contactItem.relation,
                        phone: contactItem.phone
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

    // MARK: - Contato (cartão com botão copiar)
    private func makeContactCard(name: String, relation: String?, phone: String) -> UIView {
        let cardView = UIView()
        cardView.backgroundColor = .pureWhite
        cardView.translatesAutoresizingMaskIntoConstraints = false

        let fullNameLine: String = {
                if let r = relation, !r.trimmingCharacters(in: .whitespaces).isEmpty {
                    return "\(name) (\(r))"
                } else {
                    return name
                }
            }()
        

        let nameAndRelationLabel = StandardLabel(
            labelText: fullNameLine,
            labelFont: .sfPro,
            labelType: .subHeadline,
            labelColor: .black20,
            labelWeight: .regular
        )

        let phoneLabel = StandardLabel(
            labelText: phone,
            labelFont: .sfPro,
            labelType: .callOut,
            labelColor: .black10,
            labelWeight: .medium
        )

        let copyButton = UIButton(type: .system)
        copyButton.translatesAutoresizingMaskIntoConstraints = false
        copyButton.setImage(UIImage(systemName: "doc.on.doc.fill"), for: .normal)
        copyButton.tintColor = .teal40
        copyButton.accessibilityLabel = "Copiar telefone"
        copyButton.accessibilityValue = phone
        copyButton.addTarget(self, action: #selector(didTapCopyPhoneButton(_:)), for: .touchUpInside)
        
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.spacing = 0
        
        vStack.addArrangedSubview(nameAndRelationLabel)
        vStack.addArrangedSubview(phoneLabel)

        let contentStack = UIStackView()
        contentStack.axis = .horizontal
        contentStack.alignment = .top
        
        contentStack.addArrangedSubview(vStack)
        contentStack.addArrangedSubview(copyButton)
        
        cardView.addSubview(contentStack)
        NSLayoutConstraint.activate([
            copyButton.widthAnchor.constraint(equalToConstant: 24),
            copyButton.heightAnchor.constraint(equalToConstant: 24),

            contentStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            contentStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            contentStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            contentStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12)
        ])

        return cardView
    }

    @objc private func didTapCopyPhoneButton(_ sender: UIButton) {
        let valueToCopy = sender.accessibilityValue ?? ""
        UIPasteboard.general.string = valueToCopy

        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()

        showCopiedToast(with: "Número copiado")
    }

    private func showCopiedToast(with message: String) {
        if toastLabel == nil {
            let label = UILabel()
            label.backgroundColor = UIColor.black.withAlphaComponent(0.75)
            label.textColor = .white
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            label.layer.cornerRadius = 14
            label.layer.masksToBounds = true
            label.alpha = 0.0
            label.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label)
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                label.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                label.heightAnchor.constraint(greaterThanOrEqualToConstant: 28),
                label.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
                label.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
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

    // MARK: - Filled Button
    private func makeFilledButton(icon: UIImage?, title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = .teal20
        button.layer.cornerRadius = 23
        button.heightAnchor.constraint(equalToConstant: 46).isActive = true

        let iconImageView = UIImageView(image: icon)
        iconImageView.tintColor = .white
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true

        let label = StandardLabel(
            labelText: title,
            labelFont: .sfPro,
            labelType: .callOut,
            labelColor: .pureWhite,
            labelWeight: .medium
        )

        let stackView = UIStackView(arrangedSubviews: [iconImageView, label])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false

        button.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])

        return button
    }
    
    @objc func didTapEditButton() {
        delegate?.goToPersonalData()
    }
}
