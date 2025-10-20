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
    
    private let urineColors: [UIColor] = [
        .urineLight, .urineLightYellow, .urineYellow, .urineOrange, .urineRed
    ]
    
    private var colorButtons: [UIButton] = []
    private var characteristicButtons: [UIButton] = []
    private var observationField: UITextField?
        
    init(viewModel: UrineRecordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .pureWhite
        setupLayout()
        bindViewModel()
    }
    
    // MARK: - View Layout
    
    private func setupLayout() {
        let viewTitle = StandardLabel(labelText: "Registrar urina", labelFont: .sfPro, labelType: .title2, labelColor: .black10, labelWeight: .semibold)
        
        let content = UIStackView()
        content.axis = .vertical
        content.alignment = .fill
        content.spacing = 24
        content.translatesAutoresizingMaskIntoConstraints = false
            
        let urineColorsSection = makeUrineColorSection()
        let urineCharacteristicsSection = makeUrineCharacteristicsSection()
        let urineObservationSection = makeUrineObservationSection()
        let addButton = configureAddButton()
        
        content.addArrangedSubview(viewTitle)
        content.addArrangedSubview(urineColorsSection)
        content.addArrangedSubview(urineCharacteristicsSection)
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
        let title = StandardLabel(
            labelText: "Cor da Urina?",
            labelFont: .sfPro, labelType: .callOut, labelColor: .black10, labelWeight: .semibold
        )
        
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = 18
        row.alignment = .center
        row.distribution = .fillEqually
        
        for color in urineColors {
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
    
    private func makeUrineCharacteristicsSection() -> UIView {
        let title = StandardLabel(
            labelText: "Alguma dessas características?",
            labelFont: .sfPro,
            labelType: .callOut,
            labelColor: .black10,
            labelWeight: .semibold
        )
        
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 12
        
        var currentRow = UIStackView()
        currentRow.axis = .horizontal
        currentRow.spacing = 12
        currentRow.distribution = .fillProportionally
        
        var totalWidth: CGFloat = 0
        let maxWidth = UIScreen.main.bounds.width - 32
        
        for characteristic in UrineCharacteristicsEnum.allCases {
            let button = PrimaryStyleButton(title: characteristic.displayText)
            button.backgroundColor = .black40
            button.setTitleColor(.white, for: .normal)
            button.addTarget(self, action: #selector(characteristicTapped(_:)), for: .touchUpInside)
            button.tag = characteristicButtons.count
            
            characteristicButtons.append(button)
            
            let estimatedWidth = button.intrinsicContentSize.width + 32
            if totalWidth + estimatedWidth > maxWidth {
                container.addArrangedSubview(currentRow)
                currentRow = UIStackView()
                currentRow.axis = .horizontal
                currentRow.spacing = 12
                currentRow.distribution = .fillProportionally
                totalWidth = 0
            }
            
            currentRow.addArrangedSubview(button)
            totalWidth += estimatedWidth + 12
        }
        
        container.addArrangedSubview(currentRow)
        
        let section = UIStackView(arrangedSubviews: [title, container])
        section.axis = .vertical
        section.spacing = 16
        return section
    }

    private func makeUrineObservationSection() -> UIView {
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
        let button = StandardConfirmationButton(title: "Registrar")
        button.addTarget(self, action: #selector(createUrineRecord), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    // MARK: - Actions
    
    @objc private func colorTapped(_ sender: UIButton) {
        guard let index = colorButtons.firstIndex(of: sender) else { return }
        let selectedColor = urineColors[index]
        viewModel.selectedUrineColor = selectedColor

        colorButtons.forEach { button in
            button.layer.borderColor = UIColor.white70.cgColor
            button.subviews.forEach { if $0.tag == 999 { $0.removeFromSuperview() } }
        }

        sender.layer.borderColor = UIColor.black10.cgColor
        sender.layer.borderWidth = 3

        let check = UIImageView(image: UIImage(systemName: "checkmark"))
        check.tintColor = .black10
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

    @objc private func characteristicTapped(_ sender: PrimaryStyleButton) {
        let characteristic = UrineCharacteristicsEnum.allCases[sender.tag]
        let isSelected = sender.backgroundColor == .teal20
        
        if isSelected {
            sender.backgroundColor = .black40
            sender.setTitleColor(.white, for: .normal)
            
            viewModel.selectedCharacteristics.removeAll { $0 == characteristic }
        } else {
            sender.backgroundColor = .teal20
            sender.setTitleColor(.white, for: .normal)
            viewModel.selectedCharacteristics.append(characteristic)
        }
    }
    
    @objc private func observationChanged(_ sender: UITextField) {
        viewModel.urineObservation = sender.text ?? ""
    }
    
    @objc private func createUrineRecord() {
        viewModel.createUrineRecord()
        
        delegate?.didFinishAddingUrineRecord()
    }

    
    // MARK: - Combine Bindings
    
    private func bindViewModel() {
        viewModel.$selectedUrineColor
            .sink { [weak self] color in
                guard let color, let self else { return }
                for button in self.colorButtons {
                    if button.backgroundColor == color {
                        button.layer.borderColor = UIColor.blue50.cgColor
                    } else {
                        button.layer.borderColor = UIColor.white70.cgColor
                    }
                }
            }
            .store(in: &cancellables)
    }
}
