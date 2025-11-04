//
//  StoolRecordViewController.swift
//  Altroo
//
//  Created by Raissa Parente on 02/10/25.
//

import UIKit
import Combine

protocol StoolRecordNavigationDelegate: AnyObject {
    func didFinishAddingStoolRecord()
}

final class StoolRecordViewController: GradientNavBarViewController {
    weak var delegate: StoolRecordNavigationDelegate?

    private let viewModel: StoolRecordViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let stoolColors: [UIColor] = [
        .stoolBrown, .stoolYellow, .stoolBlack, .stoolRed, .stoolGreen
    ]
    
    private var colorButtons: [UIButton] = []
    private var stoolTypesButtons: [UIButton] = []
    private var observationField: UITextField?
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: .toggleTabBarVisibility, object: nil, userInfo: ["hidden": true])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: .toggleTabBarVisibility, object: nil, userInfo: ["hidden": false])
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
            labelFont: .sfPro, labelType: .callOut, labelColor: .black10, labelWeight: .semibold
        )
        
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = 18
        row.alignment = .center
        row.distribution = .fillEqually
        
        for color in stoolColors {
            let button = UIButton(type: .system)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = color
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.white70.cgColor
            button.addTarget(self, action: #selector(colorTapped(_:)), for: .touchUpInside)

            let buttonSize = UIScreen.main.bounds.width * 0.15
            
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: buttonSize),
                button.heightAnchor.constraint(equalToConstant: buttonSize)
            ])
            button.layer.cornerRadius = buttonSize / 2

            row.addArrangedSubview(button)
            colorButtons.append(button)
        }

        
        let section = UIStackView(arrangedSubviews: [title, row])
        section.axis = .vertical
        section.alignment = .leading
        section.spacing = 16
        return section
    }
    
    private func makeStoolTypeButton(type: StoolTypesEnum, index: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.tag = index
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue80
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.layer.borderWidth = 0
        button.layer.borderColor = UIColor.blue40.cgColor

        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.alignment = .center
        contentStack.spacing = 8
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        let imageView = UIImageView(image: UIImage(named: type.displayImage))
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.required, for: .vertical)

        let titleLabel = StandardLabel(
            labelText: type.displayText,
            labelFont: .sfPro,
            labelType: .footnote,
            labelColor: .blue20,
            labelWeight: .medium
        )
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2

        contentStack.addArrangedSubview(imageView)
        contentStack.addArrangedSubview(titleLabel)

        button.addSubview(contentStack)
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 120),
            button.heightAnchor.constraint(equalToConstant: 120),

            contentStack.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 12),
            contentStack.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -12),
            contentStack.topAnchor.constraint(equalTo: button.topAnchor, constant: 12),
            contentStack.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -12),

            imageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 56)
        ])

       
        contentStack.isUserInteractionEnabled = false
        imageView.isUserInteractionEnabled = false
        titleLabel.isUserInteractionEnabled = false

        button.addTarget(self, action: #selector(typeTapped(_:)), for: .touchUpInside)
        return button
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
            row.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 2),
            row.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -2),
            row.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            row.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),

            row.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
        ])

        for (index, type) in StoolTypesEnum.allCases.enumerated() {
            let button = makeStoolTypeButton(type: type, index: index)
            stoolTypesButtons.append(button)
            row.addArrangedSubview(button)
        }

        let section = UIStackView(arrangedSubviews: [title, scrollView])
        section.axis = .vertical
        section.spacing = 12

        scrollView.heightAnchor.constraint(equalToConstant: 120).isActive = true

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
    
    @objc private func colorTapped(_ sender: UIButton) {
        guard let index = colorButtons.firstIndex(of: sender) else { return }
        let selectedColor = stoolColors[index]
        viewModel.selectedStoolColor = selectedColor

        colorButtons.forEach { button in
            button.layer.borderColor = UIColor.white70.cgColor
            button.subviews.forEach { if $0.tag == 999 { $0.removeFromSuperview() } }
        }

        sender.layer.borderColor = UIColor.pureWhite.cgColor
        sender.layer.borderWidth = 3

        let check = UIImageView(image: UIImage(systemName: "checkmark"))
        check.tintColor = .pureWhite
        check.translatesAutoresizingMaskIntoConstraints = false
        check.tag = 999
        sender.addSubview(check)
        
        let checkSize = UIScreen.main.bounds.width * 0.07
        
        NSLayoutConstraint.activate([
            check.centerXAnchor.constraint(equalTo: sender.centerXAnchor),
            check.centerYAnchor.constraint(equalTo: sender.centerYAnchor),
            check.widthAnchor.constraint(equalToConstant: checkSize),
            check.heightAnchor.constraint(equalToConstant: checkSize)
        ])
    }

    @objc private func typeTapped(_ sender: UIButton) {
        let type = StoolTypesEnum.allCases[sender.tag]
        viewModel.selectedStoolType = type

        for (i, button) in stoolTypesButtons.enumerated() {
            if i == sender.tag {
                button.layer.borderWidth = 2
                button.layer.borderColor = UIColor.blue40.cgColor
            } else {
                button.layer.borderWidth = 0
            }
        }
    }
    
    @objc private func observationChanged(_ sender: UITextField) {
        viewModel.notes = sender.text ?? ""
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
            .sink { [weak self] color in
                guard let self else { return }
                for button in self.colorButtons {
                    button.layer.borderColor = (button.backgroundColor == color) ? UIColor.blue50.cgColor : UIColor.white70.cgColor
                }
            }
            .store(in: &cancellables)

        viewModel.$selectedStoolType
            .sink { [weak self] selected in
                guard let self else { return }
                for (index, button) in self.stoolTypesButtons.enumerated() {
                    if StoolTypesEnum.allCases.indices.contains(index),
                       StoolTypesEnum.allCases[index] == selected {
                        button.layer.borderWidth = 2
                        button.layer.borderColor = UIColor.blue40.cgColor
                    } else {
                        button.layer.borderWidth = 0
                    }
                }
            }
            .store(in: &cancellables)
    }
}
