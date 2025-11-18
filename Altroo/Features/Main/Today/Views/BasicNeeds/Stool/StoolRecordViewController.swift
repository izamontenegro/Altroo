//
//  StoolRecordViewController.swift
//  Altroo
//
//  Created by Raissa Parente on 02/10/25.
//

import UIKit
import Combine
import SwiftUI

protocol StoolRecordNavigationDelegate: AnyObject {
    func didFinishAddingStoolRecord()
}

final class StoolRecordViewController: GradientNavBarViewController {
    weak var delegate: StoolRecordNavigationDelegate?
    
    var selectedStoolType: StoolTypesEnum?
    
    private let viewModel: StoolRecordViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private var stoolColorsSectionView: ColorsCardsSectionView?
    private var stoolTypesSectionView: BasicNeedsCardsScrollSectionView?
    
    private var observationField: UITextField?
    
    init(viewModel: StoolRecordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .pureWhite
        
        setupLayout()
        setupTapToDismiss()
        bindViewModel()
    }
    
    private func setupLayout() {
        let viewTitle = StandardHeaderView(title: "Registrar fezes", subtitle: "Registre uma evacuação e as características das fezes do assistido.")
        
        let content = UIStackView()
        content.axis = .vertical
        content.alignment = .fill
        content.spacing = 24
        content.translatesAutoresizingMaskIntoConstraints = false
        
        let stoolTypesSection = makeStoolTypesSection()
        let stoolColorsSection = makeStoolColorSection()
        let stoolNotesSection = makeStoolNotesSection()
        let addButton = configureAddButton()
        
        content.addArrangedSubview(viewTitle)
        content.addArrangedSubview(stoolTypesSection)
        content.addArrangedSubview(stoolColorsSection)
        content.addArrangedSubview(stoolNotesSection)
        
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
    
    private func makeStoolColorSection() -> UIView {
        let colors = StoolColorsEnum.allCases.map { $0.color }
        let titles = StoolColorsEnum.allCases.map { $0.displayText }
        
        let selectedIndex: Int?
        if let selected = viewModel.selectedStoolColor,
           let idx = StoolColorsEnum.allCases.firstIndex(of: selected) {
            selectedIndex = idx
        } else {
            selectedIndex = nil
        }
        
        let section = ColorsCardsSectionView(
            title: "Cor das Fezes?",
            colors: colors,
            titles: titles,
            selectedIndex: selectedIndex
        )
        
        section.onColorSelected = { [weak self] index, _ in
            guard let self else { return }
            let selectedEnum = StoolColorsEnum.allCases[index]
            self.viewModel.selectedStoolColor = selectedEnum
        }
        
        self.stoolColorsSectionView = section
        
        return section
    }
    
    private func makeStoolTypesSection() -> UIView {
        let types = StoolTypesEnum.allCases
        
        let imageNames = types.map { $0.displayImage }
        let subtitles = types.map { _ in "Tipo" }
        let titles = types.map { $0.displayText }
        
        let selectedIndex: Int?
        if let selected = viewModel.selectedStoolType,
           let idx = types.firstIndex(of: selected) {
            selectedIndex = idx
        } else {
            selectedIndex = nil
        }
        
        let section = BasicNeedsCardsScrollSectionView(
            title: "Como foi o tipo de Fezes?",
            imageNames: imageNames,
            subtitles: subtitles,
            titles: titles,
            selectedIndex: selectedIndex,
            scrollHeight: 170,
            spacing: 12,
            leadingPadding: 5,
            trailingContentInset: 32
        )
        
        section.onCardSelected = { [weak self] index in
            guard let self else { return }
            let selectedType = StoolTypesEnum.allCases[index]
            self.viewModel.selectedStoolType = selectedType
        }
        
        self.stoolTypesSectionView = section
        return section
    }
    
    private func makeStoolNotesSection() -> UIView {
        let title = StandardLabel(
            labelText: "Observação",
            labelFont: .sfPro, labelType: .callOut, labelColor: .black10, labelWeight: .semibold
        )
        
        let field = StandardTextfield()
        field.addTarget(self, action: #selector(observationChanged(_:)), for: .editingChanged)
        
        self.observationField = field
        
        let section = UIStackView(arrangedSubviews: [title, field])
        section.axis = .vertical
        section.spacing = 8
        return section
    }
    
    // MARK: - Components
    
    private func makeStoolTypeCard(type: StoolTypesEnum, index: Int) -> UIView {
        let card = BasicNeedsCardHostingView(
            imageName: type.displayImage,
            subtitle: "Tipo",
            title: type.displayText,
            isSelected: viewModel.selectedStoolType == type,
            action: { [weak self] in
                guard let self else { return }
                self.viewModel.selectedStoolType = type
            }
        )
        
        card.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            card.widthAnchor.constraint(equalToConstant: 120),
            card.heightAnchor.constraint(equalToConstant: 160)
        ])
        
        return card
    }
    private func configureAddButton() -> UIView {
        let button = StandardConfirmationButton(title: "Adicionar")
        button.addTarget(self, action: #selector(createStoolRecord), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    // MARK: - Actions
    
    @objc private func typeTapped(_ sender: UIButton) {
        let type = StoolTypesEnum.allCases[sender.tag]
        selectedStoolType = type
        viewModel.selectedStoolType = type
    }
    
    @objc private func observationChanged(_ sender: UITextField) {
        viewModel.notes = sender.text ?? "--"
    }
    
    @objc private func createStoolRecord() {
        viewModel.createStoolRecord()
        
        delegate?.didFinishAddingStoolRecord()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupTapToDismiss() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    // MARK: - Combine Binding
    
    private func bindViewModel() {
        viewModel.$selectedStoolColor
            .sink { [weak self] selected in
                guard let self else { return }
                
                let index: Int?
                if let selected,
                   let idx = StoolColorsEnum.allCases.firstIndex(of: selected) {
                    index = idx
                } else {
                    index = nil
                }
                
                self.stoolColorsSectionView?.updateSelection(index: index)
            }
            .store(in: &cancellables)
        
        viewModel.$selectedStoolType
            .sink { [weak self] selected in
                guard let self else { return }
                
                let index: Int?
                if let selected,
                   let idx = StoolTypesEnum.allCases.firstIndex(of: selected) {
                    index = idx
                } else {
                    index = nil
                }
                
                self.stoolTypesSectionView?.updateSelection(index: index)
            }
            .store(in: &cancellables)
    }
}
