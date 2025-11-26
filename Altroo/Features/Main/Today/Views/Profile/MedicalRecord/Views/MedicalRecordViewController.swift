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
        super.viewWillAppear(animated)
        viewModel.reload()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        bindViewModel()
    }

    private func bindViewModel() {
        viewModel.$reloadToken
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
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
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
        
        let headerView = makeHeaderSection(percent: viewModel.completionPercentage)
        contentStackView.addArrangedSubview(headerView)

        if viewModel.completionPercentage < 1.0 {
            let alertView = makeCompletionAlertAndButton()
            contentStackView.addArrangedSubview(alertView)
        }
        
        contentStackView.addArrangedSubview(headerView)
        contentStackView.spacing = 16
        
        let personalSection = PersonalDataSectionView(
                name: viewModel.getName(),
                birthDate: viewModel.getBirthDate(),
                weight: viewModel.getWeight(),
                height: viewModel.getHeight(),
                address: viewModel.getAddress(),
                emergencyContact: viewModel.getContactDisplayItem(),
                copyTarget: self,
                copyAction: #selector(didTapCopyPhoneButton(_:)),
                editTarget: self,
                editAction: #selector(didTapEditPersonalData)
            )
        
        contentStackView.addArrangedSubview(personalSection)
        
        let healthProblemsSection = HealthProblemsSectionView(
            diseasesText: viewModel.getDiseasesText(),
            surgeryItems: viewModel.getSurgeriesItems(),
            allergiesText: viewModel.getAllergiesText(),
            observationText: viewModel.getObservationText(),
            editTarget: self,
            editAction: #selector(didTapEditHealthProblems)
        )
        contentStackView.addArrangedSubview(healthProblemsSection)
        
        let physicalSection = PhysicalStateSectionView(
            vision: viewModel.getVisionText(),
            hearing: viewModel.getHearingText(),
            mobility: viewModel.getMobilityText(),
            oralHealth: viewModel.getOralHealthText(),
            editTarget: self,
            editAction: #selector(didTapEditPhysicalState)
        )
        contentStackView.addArrangedSubview(physicalSection)
        
        let mentalSection = MentalStateSectionView(
            emotionalState: viewModel.getEmotionalStateText(),
            orientationState: viewModel.getOrientationStateText(),
            memoryState: viewModel.getMemoryStateText(),
            editTarget: self,
            editAction: #selector(didTapEditMentalState)
        )
        contentStackView.addArrangedSubview(mentalSection)
        
        let personalCareSection = PersonalCareSectionView(
            bath: viewModel.getBathStateText(),
            hygiene: viewModel.getHygieneStateText(),
            excretion: viewModel.getExcretionStateText(),
            feeding: viewModel.getFeedingStateText(),
            equipment: viewModel.getEquipmentText(),
            editTarget: self,
            editAction: #selector(didTapEditPersonalCare)
        )
        contentStackView.addArrangedSubview(personalCareSection)
    }

    func makeHeaderSection(percent: CGFloat) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        let titleLabel = StandardLabel(
            labelText: "Ficha do Assistido",
            labelFont: .sfPro,
            labelType: .title2,
            labelColor: .black10,
            labelWeight: .semibold
        )
        let subtitleLabel = StandardLabel(
            labelText: "Este é o espaço onde ficam reunidas todas as informações de saúde do assistido, prontas para consulta.",
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
        
        let headerStackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, progressRowStackView])
        headerStackView.axis = .vertical
        headerStackView.spacing = 4
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(headerStackView)
        containerView.addSubview(updatedStack)
        
        NSLayoutConstraint.activate([
            trackView.trailingAnchor.constraint(equalTo: percentageLabel.leadingAnchor, constant: -10),
            trackView.heightAnchor.constraint(equalToConstant: 15),
            trackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 110),
            fillView.leadingAnchor.constraint(equalTo: trackView.leadingAnchor),
            fillView.centerYAnchor.constraint(equalTo: trackView.centerYAnchor),
            fillView.heightAnchor.constraint(equalTo: trackView.heightAnchor),
            fillView.widthAnchor.constraint(equalTo: trackView.widthAnchor, multiplier: max(0, min(1, percent))),
            
            updatedStack.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 3),
            
            headerStackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            headerStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            headerStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            headerStackView.bottomAnchor.constraint(equalTo: updatedStack.topAnchor),
            
            updatedStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
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
        let alertBoxView = UIView()
        alertBoxView.backgroundColor = UIColor.red80
        alertBoxView.layer.cornerRadius = 8
        
        let alertIconImageView = UIImageView(image: UIImage(systemName: "exclamationmark.triangle"))
        alertIconImageView.tintColor = .red20
        alertIconImageView.translatesAutoresizingMaskIntoConstraints = false
        alertIconImageView.widthAnchor.constraint(equalToConstant: 34).isActive = true
        alertIconImageView.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        let alertLabel = StandardLabel(
            labelText: "Complete o preenchimento para manter as informações do assistido à mão se precisar.",
            labelFont: .sfPro,
            labelType: .callOut,
            labelColor: .red20,
            labelWeight: .regular
        )
        alertLabel.numberOfLines = 0
        alertLabel.textAlignment = .left
        
        let alertStackView = UIStackView(arrangedSubviews: [alertIconImageView, alertLabel])
        alertStackView.axis = .horizontal
        alertStackView.alignment = .center
        alertStackView.spacing = 8
        alertStackView.translatesAutoresizingMaskIntoConstraints = false
        
        alertBoxView.addSubview(alertStackView)
        
        NSLayoutConstraint.activate([
            alertStackView.topAnchor.constraint(equalTo: alertBoxView.topAnchor, constant: 8),
            alertStackView.bottomAnchor.constraint(equalTo: alertBoxView.bottomAnchor, constant: -8),
            alertStackView.leadingAnchor.constraint(equalTo: alertBoxView.leadingAnchor, constant: 8),
            alertStackView.trailingAnchor.constraint(equalTo: alertBoxView.trailingAnchor, constant: -8)
        ])
        
        return alertBoxView
    }

    // MARK: - actions

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
    
    // MARK: - Edit actions

    @objc private func didTapEditPersonalData() {
        delegate?.goToPersonalData()
    }

    @objc private func didTapEditHealthProblems() {
        delegate?.goToHealthProblems()
    }

    @objc private func didTapEditPhysicalState() {
        delegate?.goToPhysicalState()
    }

    @objc private func didTapEditMentalState() {
        delegate?.goToMentalState()
    }

    @objc private func didTapEditPersonalCare() {
        delegate?.goToPersonalCare()
    }
}
