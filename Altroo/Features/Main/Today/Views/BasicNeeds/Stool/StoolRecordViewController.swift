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
    
    private let viewModel: StoolRecordViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private var stoolColorCards: [BasicNeedsColorCardHostingView] = []
    private var stoolTypesButtons: [UIView] = []
    private var observationField: UITextField?
    
    var selectedStoolType: StoolTypesEnum?
    
    init(viewModel: StoolRecordViewModel) {
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
        setupTapToDismiss()
        bindViewModel()
    }
    
    // MARK: - View Layout
    
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
        let title = StandardLabel(
            labelText: "Cor das Fezes?",
            labelFont: .sfPro,
            labelType: .callOut,
            labelColor: .black10,
            labelWeight: .semibold
        )
        
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = 6
        row.alignment = .fill
        row.distribution = .fillEqually
        
        for color in StoolColorsEnum.allCases {
            let card = BasicNeedsColorCardHostingView(
                color: color,
                isSelected: viewModel.selectedStoolColor == color,
                action: { [weak self] in
                    guard let self else { return }
                    self.viewModel.selectedStoolColor = color
                }
            )
            
            card.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                card.widthAnchor.constraint(equalToConstant: 68),
                card.heightAnchor.constraint(equalToConstant: 98)
            ])
            
            row.addArrangedSubview(card)
            stoolColorCards.append(card)
        }
        
        let section = UIStackView(arrangedSubviews: [title, row])
        section.axis = .vertical
        section.alignment = .leading
        section.spacing = 16
        return section
    }
    private func makeStoolTypeCard(type: StoolTypesEnum, index: Int) -> UIView {
        let card = BasicNeedsCardHostingView(
            type: type,
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
    
    private func makeStoolTypesSection() -> UIView {
        let title = StandardLabel(
            labelText: "Como foi o tipo de Fezes?",
            labelFont: .sfPro,
            labelType: .callOut,
            labelColor: .black10,
            labelWeight: .semibold
        )
        
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let row = UIStackView()
        row.axis = .horizontal
        row.alignment = .fill
        row.spacing = 12
        row.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(row)
        NSLayoutConstraint.activate([
            row.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 5),
            row.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -2),
            row.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            row.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            row.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
        ])
        
        for (index, type) in StoolTypesEnum.allCases.enumerated() {
            let card = makeStoolTypeCard(type: type, index: index)
            row.addArrangedSubview(card)
            stoolTypesButtons.append(card)
            
        }
        
        let section = UIStackView(arrangedSubviews: [title, scrollView])
        section.axis = .vertical
        section.spacing = 12
        
        scrollView.heightAnchor.constraint(equalToConstant: 170).isActive = true
        
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
        print(selectedStoolType?.displayText)
        viewModel.selectedStoolType = type
    }
    
    @objc private func observationChanged(_ sender: UITextField) {
        viewModel.notes = sender.text ?? "--"
    }
    
    @objc private func createStoolRecord() {
        viewModel.createStoolRecord()
        
        delegate?.didFinishAddingStoolRecord()
    }
    
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
        viewModel.$selectedStoolColor
            .sink { [weak self] selected in
                guard let self else { return }
                
                for card in self.stoolColorCards {
                    card.setSelected(card.colorEnum == selected)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$selectedStoolType
            .sink { [weak self] selected in
                guard let self else { return }
                
                for case let card as BasicNeedsCardHostingView in self.stoolTypesButtons {
                    card.setSelected(card.type == selected)
                }
            }
            .store(in: &cancellables)
    }
}

final class BasicNeedsCardHostingView: UIView {
    private var hostingController: UIHostingController<BasicNeedsTemplateCard>
    
    let type: StoolTypesEnum
    private let imageName: String
    private let subtitle: String
    private let titleText: String
    private let action: () -> Void

    init(type: StoolTypesEnum,
         imageName: String,
         subtitle: String,
         title: String,
         isSelected: Bool = false,
         action: @escaping () -> Void) {

        self.type = type
        self.imageName = imageName
        self.subtitle = subtitle
        self.titleText = title
        self.action = action
        
        let swiftUIView = BasicNeedsTemplateCard(
            imageName: imageName,
            subtitle: subtitle,
            title: title,
            isSelected: isSelected,
            action: action
        )

        hostingController = UIHostingController(rootView: swiftUIView)

        super.init(frame: .zero)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.backgroundColor = .clear

        addSubview(hostingController.view)

        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setSelected(_ isSelected: Bool) {
        hostingController.rootView = BasicNeedsTemplateCard(
            imageName: imageName,
            subtitle: subtitle,
            title: titleText,
            isSelected: isSelected,
            action: action
        )
    }
}

final class BasicNeedsColorCardHostingView: UIView {
    private var hostingController: UIHostingController<BasicNeedsColorCard>
    
    let colorEnum: StoolColorsEnum
    private let colorName: UIColor
    private let titleText: String
    private let action: () -> Void
    
    init(color: StoolColorsEnum,
         isSelected: Bool = false,
         action: @escaping () -> Void) {
        
        self.colorEnum = color
        self.colorName = color.color
        self.titleText = color.displayText
        self.action = action
        
        let swiftUIView = BasicNeedsColorCard(
            colorName: colorName,
            title: titleText,
            isSelected: isSelected,
            action: action
        )
        
        hostingController = UIHostingController(rootView: swiftUIView)
        
        super.init(frame: .zero)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.backgroundColor = .clear
        
        addSubview(hostingController.view)
        
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setSelected(_ isSelected: Bool) {
        hostingController.rootView = BasicNeedsColorCard(
            colorName: colorName,
            title: titleText,
            isSelected: isSelected,
            action: action
        )
    }
}
