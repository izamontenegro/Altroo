//
//  UrineRecordViewController.swift
//  Altroo
//
//  Created by Raissa Parente on 02/10/25.
//

import UIKit
import Combine

protocol UrineRecordNavigationDelegate: AnyObject {
    func didFinishAddingUrineRecord()
}

final class UrineRecordViewController: UIViewController {
    weak var delegate: UrineRecordNavigationDelegate?
    private var keyboardHandler: KeyboardHandler?

    private let viewModel: UrineRecordViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private var urineColorsSectionView: ColorsCardsSectionView?
    private var observationView: ObservationView?
    
    init(viewModel: UrineRecordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .pureWhite
        setupLayout()
        bindViewModel()
        setupTapToDismiss()
        configureNavBar()
        
        keyboardHandler = KeyboardHandler(viewController: self, scrollView: scrollView)
    }
    
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    // MARK: - View Layout
    private func setupLayout() {
        let content = UIStackView()
        content.axis = .vertical
        content.alignment = .fill
        content.spacing = 24
        content.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(content)

        let viewTitle = StandardHeaderView(
            title: "record_urine".localized,
            subtitle: "Registre uma micção e as características da urina do assistido."
        )

        let urineColorsSection = makeUrineColorSection()
        let urineObservationSection = makeUrineObservationSection()
        let addButton = configureAddButton()

        content.addArrangedSubview(viewTitle)
        content.addArrangedSubview(urineColorsSection)
        content.addArrangedSubview(urineObservationSection)

        let buttonContainer = UIView()
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        buttonContainer.addSubview(addButton)

        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: buttonContainer.centerXAnchor),
            addButton.topAnchor.constraint(equalTo: buttonContainer.topAnchor),
            addButton.bottomAnchor.constraint(equalTo: buttonContainer.bottomAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 188),
            addButton.heightAnchor.constraint(equalToConstant: 48)
        ])

        let bottomSpacer = UIView()
        bottomSpacer.heightAnchor.constraint(equalToConstant: 32).isActive = true

        content.addArrangedSubview(buttonContainer)
        content.addArrangedSubview(bottomSpacer)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            content.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 24),
            content.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            content.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            content.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -24),

            content.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32)
        ])
    }
    private func configureNavBar() {
        let closeButton = UIBarButtonItem(title: "Fechar", style: .done, target: self, action: #selector(closeTapped))
        closeButton.tintColor = .blue20
        navigationItem.leftBarButtonItem = closeButton
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        navigationItem.scrollEdgeAppearance = appearance
    }
    
    // MARK: - Sections
    
    private func makeUrineColorSection() -> UIView {
        let colors = UrineColorsEnum.allCases.map { $0.color }
        let titles = UrineColorsEnum.allCases.map { $0.displayText }
        
        let selectedIndex: Int?
        if let selected = viewModel.selectedUrineColor,
           let idx = UrineColorsEnum.allCases.firstIndex(of: selected) {
            selectedIndex = idx
        } else {
            selectedIndex = nil
        }
        
        let section = ColorsCardsSectionView(
            title: "Qual foi a coloração da urina?",
            colors: colors,
            titles: titles,
            selectedIndex: selectedIndex
        )
        
        section.onColorSelected = { [weak self] index, _ in
            guard let self else { return }
            let selectedEnum = UrineColorsEnum.allCases[index]
            self.viewModel.selectedUrineColor = selectedEnum
        }
        
        self.urineColorsSectionView = section
        return section
    }
    
    private func makeUrineObservationSection() -> UIView {
        let title = StandardLabel(
            labelText: "Observação",
            labelFont: .sfPro,
            labelType: .callOut,
            labelColor: .black10,
            labelWeight: .semibold
        )

        let obs = ObservationView(placeholder: "Detalhes opcionais.")
        obs.delegate = self
        obs.translatesAutoresizingMaskIntoConstraints = false
        
        self.observationView = obs
        
        let section = UIStackView(arrangedSubviews: [title, obs])
        section.axis = .vertical
        section.spacing = 8
        return section
    }
    
    private func configureAddButton() -> UIView {
        let button = StandardConfirmationButton(title: "Salvar")
        button.addTarget(self, action: #selector(createUrineRecord), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    // MARK: - Actions
    @objc private func createUrineRecord() {
        viewModel.createUrineRecord()
        delegate?.didFinishAddingUrineRecord()
        dismiss(animated: true)

    }
    
    // MARK: - Keyboard
    private func setupTapToDismiss() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func closeTapped() {
        dismiss(animated: true)
    }

    
    // MARK: - Combine Bindings
    private func bindViewModel() {
        viewModel.$selectedUrineColor
            .sink { [weak self] selected in
                guard let self else { return }
                
                let idx: Int?
                if let selected,
                   let index = UrineColorsEnum.allCases.firstIndex(of: selected) {
                    idx = index
                } else {
                    idx = nil
                }
                
                self.urineColorsSectionView?.updateSelection(index: idx)
            }
            .store(in: &cancellables)
    }
}

// MARK: - ObservationViewDelegate
extension UrineRecordViewController: ObservationViewDelegate {
    func observationView(_ view: ObservationView, didChangeText text: String) {
        viewModel.urineObservation = text.isEmpty ? "--" : text
    }
}
