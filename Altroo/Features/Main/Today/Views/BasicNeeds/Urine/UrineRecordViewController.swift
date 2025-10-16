//
//  UrineRecordViewController.swift
//  Altroo
//
//  Created by Raissa Parente on 02/10/25.
//

import UIKit
import Combine

final class UrineRecordViewController: GradientNavBarViewController {
    private let viewModel: UrineRecordViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let urineColors: [UIColor] = [
        .urineLight, .urineLightYellow, .urineYellow, .urineOrange, .urineRed
    ]
    
    private var colorButtons: [UIButton] = []
    private var characteristicButtons: [UIButton] = []
    private var observationField: UITextField?
    
    // MARK: - Init
    
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
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        let content = UIStackView()
        content.axis = .vertical
        content.alignment = .fill
        content.spacing = 24
        content.translatesAutoresizingMaskIntoConstraints = false
        
        let urineColorsSection = makeUrineColorSection()
        let urineCharacteristicsSection = makeUrineCharacteristicsSection()
        let urineObservationSection = makeUrineObservationSection()
        let addButton = configureAddButton()
        
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
        row.distribution = .equalSpacing
        
        for color in urineColors {
            let button = UIButton(type: .system)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = color
            button.layer.cornerRadius = 30
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.white70.cgColor
            button.addTarget(self, action: #selector(colorTapped(_:)), for: .touchUpInside)
            
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 60),
                button.heightAnchor.constraint(equalToConstant: 60)
            ])
            
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
            labelFont: .sfPro, labelType: .callOut, labelColor: .black10, labelWeight: .semibold
        )
        
        let column = UIStackView()
        column.axis = .vertical
        column.spacing = 12
        
        for characteristic in UrineCharacteristicsEnum.allCases {
            let button = UIButton(type: .system)
            button.setTitle(characteristic.rawValue.capitalized, for: .normal)
            button.setTitleColor(.black10, for: .normal)
            button.contentHorizontalAlignment = .left
            button.layer.cornerRadius = 6
            button.backgroundColor = .white70
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            button.addTarget(self, action: #selector(characteristicTapped(_:)), for: .touchUpInside)
            button.tag = characteristicButtons.count
            column.addArrangedSubview(button)
            characteristicButtons.append(button)
        }
        
        let section = UIStackView(arrangedSubviews: [title, column])
        section.axis = .vertical
        section.spacing = 16
        return section
    }
    
    private func makeUrineObservationSection() -> UIView {
        let title = StandardLabel(
            labelText: "Observação",
            labelFont: .sfPro, labelType: .callOut, labelColor: .black10, labelWeight: .semibold
        )
        
        let field = UITextField()
        field.placeholder = "Observação"
        field.borderStyle = .roundedRect
        field.backgroundColor = .white70
        field.addTarget(self, action: #selector(observationChanged(_:)), for: .editingChanged)
        
        self.observationField = field
        
        let section = UIStackView(arrangedSubviews: [title, field])
        section.axis = .vertical
        section.spacing = 8
        return section
    }
    
    private func configureAddButton() -> UIView {
        let button = StandardConfirmationButton(title: "Adicionar")
        button.addTarget(self, action: #selector(createUrineRecord), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    // MARK: - Actions
    
    @objc private func colorTapped(_ sender: UIButton) {
        guard let index = colorButtons.firstIndex(of: sender) else { return }
        let selectedColor = urineColors[index]
        viewModel.selectedUrineColor = selectedColor
        
        // destaca a cor selecionada
        colorButtons.forEach { $0.layer.borderColor = UIColor.white70.cgColor }
        sender.layer.borderColor = UIColor.blue50.cgColor
    }
    
    @objc private func characteristicTapped(_ sender: UIButton) {
        let characteristic = UrineCharacteristicsEnum.allCases[sender.tag]
        
        if viewModel.selectedCharacteristics.contains(characteristic) {
            viewModel.selectedCharacteristics.removeAll { $0 == characteristic }
            sender.backgroundColor = .white70
        } else {
            viewModel.selectedCharacteristics.append(characteristic)
            sender.backgroundColor = .blue10
        }
    }
    
    @objc private func observationChanged(_ sender: UITextField) {
        viewModel.urineObservation = sender.text ?? ""
    }
    
    @objc private func createUrineRecord() {
        viewModel.createUrineRecord()
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
