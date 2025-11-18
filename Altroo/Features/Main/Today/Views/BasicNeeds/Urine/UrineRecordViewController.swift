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

final class UrineRecordViewController: GradientNavBarViewController {
    weak var delegate: UrineRecordNavigationDelegate?

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
    }
    
    // MARK: - View Layout
    private func setupLayout() {
        let viewTitle = StandardHeaderView(
            title: "Registrar urina",
            subtitle: "Registre uma micção e as características da urina do assistido."
        )
        
        let content = UIStackView()
        content.axis = .vertical
        content.alignment = .fill
        content.spacing = 24
        content.translatesAutoresizingMaskIntoConstraints = false
            
        let urineColorsSection = makeUrineColorSection()
        let urineObservationSection = makeUrineObservationSection()
        let addButton = configureAddButton()
        
        content.addArrangedSubview(viewTitle)
        content.addArrangedSubview(urineColorsSection)
        content.addArrangedSubview(urineObservationSection)
        
        view.addSubview(content)
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            content.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            content.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
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
