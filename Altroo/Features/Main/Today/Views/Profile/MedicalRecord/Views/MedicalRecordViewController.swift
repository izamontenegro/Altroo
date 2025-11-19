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
    private var cancellableSet = Set<AnyCancellable>()
    private var toastLabel: UILabel?
    private let scrollViewTag = 7001
    private let contentStackViewTag = 7002
    
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
            .store(in: &cancellableSet)
    }

    private func setupLayout() {
        view.backgroundColor = .pureWhite
        
        let scrollView = UIScrollView()
        scrollView.tag = scrollViewTag
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        let contentStackView = UIStackView()
        contentStackView.tag = contentStackViewTag
        contentStackView.axis = .vertical
        contentStackView.spacing = 24
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30),
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -40),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        reloadContent()
    }
    
    private func resolveContentStackView() -> UIStackView? {
        view.viewWithTag(contentStackViewTag) as? UIStackView
    }

    private func reloadContent() {
        guard let contentStackView = resolveContentStackView() else { return }
        contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        contentStackView.addArrangedSubview(makeHeaderSection(percent: viewModel.completionPercentage))
        contentStackView.addArrangedSubview(makeCompletionAlertAndButton())
        for section in viewModel.sections {
            contentStackView.addArrangedSubview(makeSection(
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
        let percentageLabel = StandardLabel(
            labelText: "\(Int(round(percent * 100)))%",
            labelFont: .sfPro,
            labelType: .callOut,
            labelColor: .blue20,
            labelWeight: .medium
        )
        percentageLabel.setContentHuggingPriority(.required, for: .horizontal)
        percentageLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        let progressRowStackView = UIStackView(arrangedSubviews: [trackView, percentageLabel])
        progressRowStackView.axis = .horizontal
        progressRowStackView.alignment = .center
        progressRowStackView.spacing = 10
        let headerStackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, progressRowStackView])
        headerStackView.axis = .vertical
        headerStackView.spacing = 4
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(headerStackView)
        NSLayoutConstraint.activate([
            trackView.trailingAnchor.constraint(equalTo: percentageLabel.leadingAnchor, constant: -10),
            trackView.heightAnchor.constraint(equalToConstant: 15),
            trackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 110),
            fillView.leadingAnchor.constraint(equalTo: trackView.leadingAnchor),
            fillView.centerYAnchor.constraint(equalTo: trackView.centerYAnchor),
            fillView.heightAnchor.constraint(equalTo: trackView.heightAnchor),
            fillView.widthAnchor.constraint(equalTo: trackView.widthAnchor, multiplier: max(0, min(1, percent))),
            headerStackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            headerStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            headerStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            headerStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        DispatchQueue.main.async {
            containerView.layoutIfNeeded()
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [UIColor.blue10.cgColor, UIColor.blue50.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.frame = fillView.bounds
            gradientLayer.cornerRadius = fillView.layer.cornerRadius
            fillView.layer.insertSublayer(gradientLayer, at: 0)
        }
        return containerView
    }

    private func makeCompletionAlertAndButton() -> UIView {
        let wrapperStackView = UIStackView()
        wrapperStackView.axis = .vertical
        wrapperStackView.spacing = -15
        wrapperStackView.translatesAutoresizingMaskIntoConstraints = false
        let alertBoxView = UIView()
        alertBoxView.backgroundColor = UIColor.teal80
        alertBoxView.layer.cornerRadius = 5
        let alertIconImageView = UIImageView(image: UIImage(systemName: "exclamationmark.triangle.fill"))
        alertIconImageView.tintColor = .teal10
        alertIconImageView.translatesAutoresizingMaskIntoConstraints = false
        alertIconImageView.widthAnchor.constraint(equalToConstant: 36).isActive = true
        alertIconImageView.heightAnchor.constraint(equalToConstant: 36).isActive = true
        let alertLabel = StandardLabel(
            labelText: "Finalize o preenchimento para ter os dados de saúde do paciente à mão quando precisar.",
            labelFont: .sfPro,
            labelType: .subHeadline,
            labelColor: .teal10,
            labelWeight: .regular
        )
        alertLabel.numberOfLines = 0
        let alertStackView = UIStackView(arrangedSubviews: [alertIconImageView, alertLabel])
        alertStackView.axis = .horizontal
        alertStackView.alignment = .center
        alertStackView.spacing = 10
        alertStackView.translatesAutoresizingMaskIntoConstraints = false
        alertBoxView.addSubview(alertStackView)
        NSLayoutConstraint.activate([
            alertStackView.topAnchor.constraint(equalTo: alertBoxView.topAnchor, constant: 8),
            alertStackView.bottomAnchor.constraint(equalTo: alertBoxView.bottomAnchor, constant: -23),
            alertStackView.leadingAnchor.constraint(equalTo: alertBoxView.leadingAnchor, constant: 8),
            alertStackView.trailingAnchor.constraint(equalTo: alertBoxView.trailingAnchor, constant: -8)
        ])
        let editButton = LargeFilledButton(
            title: "Editar Ficha Médica",
            icon: UIImage(systemName: "square.and.pencil")
        )
        wrapperStackView.addArrangedSubview(alertBoxView)
        wrapperStackView.addArrangedSubview(editButton)
        editButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapEditButton))
        editButton.addGestureRecognizer(tapGesture)
        return wrapperStackView
    }

    private func makeSubsectionHeader(_ text: String) -> UIView {
        let titleLabel = StandardLabel(
            labelText: text,
            labelFont: .sfPro,
            labelType: .body,
            labelColor: .blue20,
            labelWeight: .regular
        )
        let wrapperStackView = UIStackView(arrangedSubviews: [titleLabel])
        wrapperStackView.axis = .vertical
        wrapperStackView.spacing = 4
        wrapperStackView.translatesAutoresizingMaskIntoConstraints = false
        return wrapperStackView
    }

    private func makeSection(title: String, rows: [InformationRow], icon: String) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        let headerView = makeSectionHeader(title: title, icon: icon)
        let bodyStackView = UIStackView()
        bodyStackView.axis = .vertical
        bodyStackView.spacing = 10
        bodyStackView.translatesAutoresizingMaskIntoConstraints = false
        for row in rows {
            if row.title == "Cirurgias", row.value.isEmpty, !viewModel.surgeryDisplayItems.isEmpty {
                bodyStackView.addArrangedSubview(makeSubsectionHeader("Cirurgias"))
                let groupStackView = UIStackView()
                groupStackView.axis = .vertical
                groupStackView.spacing = 4
                groupStackView.translatesAutoresizingMaskIntoConstraints = false
                for surgery in viewModel.surgeryDisplayItems {
                    let itemView = MedicalRecordInfoItemView(
                        infotitle: "",
                        primaryText: surgery.primary,
                        secondaryText: surgery.secondary
                    )
                    itemView.translatesAutoresizingMaskIntoConstraints = false
                    groupStackView.addArrangedSubview(itemView)
                }
                bodyStackView.addArrangedSubview(groupStackView)
                continue
            }
            if row.title == "emergency_contact".localized, row.value.isEmpty, !viewModel.contactDisplayItems.isEmpty {
                bodyStackView.addArrangedSubview(makeSubsectionHeader("emergency_contact".localized))
                let groupStackView = UIStackView()
                groupStackView.axis = .vertical
                groupStackView.spacing = 4
                groupStackView.translatesAutoresizingMaskIntoConstraints = false
                for contact in viewModel.contactDisplayItems {
                    let cardView = ContactCardView(
                        name: contact.name,
                        relation: contact.relationship,
                        phone: contact.phone,
                        copyTarget: self,
                        copyAction: #selector(didTapCopyPhoneButton(_:))
                    )
                    groupStackView.addArrangedSubview(cardView)
                }
                bodyStackView.addArrangedSubview(groupStackView)
                continue
            }
            let itemView = MedicalRecordInfoItemView(
                infotitle: row.title,
                infoDescription: row.value
            )
            itemView.translatesAutoresizingMaskIntoConstraints = false
            bodyStackView.addArrangedSubview(itemView)
        }
        containerView.addSubview(headerView)
        containerView.addSubview(bodyStackView)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: containerView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 36),
            bodyStackView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8),
            bodyStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            bodyStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            bodyStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
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
        let titleStackView = UIStackView(arrangedSubviews: [iconImageView, titleLabel])
        titleStackView.axis = .horizontal
        titleStackView.spacing = 8
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleStackView)
        NSLayoutConstraint.activate([
            titleStackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 12),
            titleStackView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func didTapCopyPhoneButton(_ sender: UIButton) {
        let valueToCopy = sender.accessibilityValue ?? ""
        UIPasteboard.general.string = valueToCopy
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        showCopiedToast(with: "Número copiado")
    }
    
    @objc func didTapEditButton() {
        delegate?.goToPersonalData()
    }
}
