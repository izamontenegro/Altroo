//
//  UrineRecordViewController.swift
//  Altroo
//
//  Created by Raissa Parente on 02/10/25.
//

import UIKit
import SwiftUI

final class UrineRecordViewController: GradientNavBarViewController {
    //    let viewModel: UrineRecordViewModel?
    
    private let urineColors: [UIColor] = [
        .urineLight, .urineLightYellow, .urineYellow, .urineOrange, .urineRed
    ]
    //
    //    init(viewModel: UrineRecordViewModel) {
    //        self.viewModel = viewModel
    //        super.init(nibName: nil, bundle: nil)
    //    }
    //
    //    @MainActor required init?(coder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .pureWhite
        setupLayout()
    }
    
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

        view.addSubview(addButton)
        view.addSubview(content)
        
        NSLayoutConstraint.activate([
            content.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            content.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            content.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            content.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
            
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -24)
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
            let circle = UIView()
            circle.translatesAutoresizingMaskIntoConstraints = false
            circle.layer.cornerRadius = 30
            circle.backgroundColor = color
            circle.layer.borderWidth = 2
            circle.layer.borderColor = UIColor.white70.cgColor
            
            NSLayoutConstraint.activate([
                circle.widthAnchor.constraint(equalToConstant: 60),
                circle.heightAnchor.constraint(equalToConstant: 60)
            ])
            
            row.addArrangedSubview(circle)
        }
        
        let section = UIStackView(arrangedSubviews: [title, row])
        section.axis = .vertical
        section.alignment = .leading
        section.spacing = 16
        section.translatesAutoresizingMaskIntoConstraints = false
        return section
    }
    
    private func makeUrineCharacteristicsSection() -> UIView {
        let title = StandardLabel(
            labelText: "Alguma dessas características?",
            labelFont: .sfPro, labelType: .callOut, labelColor: .black10, labelWeight: .semibold
        )
        
        let column = UIStackView()
        column.axis = .vertical
        column.alignment = .fill
        column.spacing = 12
        
        for characteristic in UrineCharacteristicsEnum.allCases {
            let label = StandardLabel(
                labelText: characteristic.rawValue.capitalized,
                labelFont: .sfPro, labelType: .body, labelColor: .black10
            )
            column.addArrangedSubview(label)
        }
        
        let section = UIStackView(arrangedSubviews: [title, column])
        section.axis = .vertical
        section.alignment = .leading
        section.spacing = 16
        section.translatesAutoresizingMaskIntoConstraints = false
        return section
    }
    
    private func makeUrineObservationSection() -> UIView {
        let observationSectionTitle = StandardLabel(
            labelText: "Observação",
            labelFont: .sfPro, labelType: .callOut, labelColor: .black10, labelWeight: .semibold
        )
        
        let observationTexfield = StandardTextfield(width: 370,
                                                    height: 38,
                                                    title: StandardLabel(labelText: "Observação",
                                                                         labelFont: .sfPro,
                                                                         labelType: .callOut,
                                                                         labelColor: UIColor(resource: .black10),
                                                                         labelWeight: .semibold),
                                                    placeholder: "Observação")
        
        let urineObservationSection = UIStackView()
        urineObservationSection.axis = .vertical
        urineObservationSection.spacing = 8
        
        urineObservationSection.addArrangedSubview(observationSectionTitle)
        urineObservationSection.addArrangedSubview(observationTexfield)

        
        
        return urineObservationSection
    }
    
    // MARK: - Add button
    
    private func configureAddButton() -> UIView {
        let addButton = StandardConfirmationButton(title: "Adicionar")
        addButton.translatesAutoresizingMaskIntoConstraints = false
        return addButton
    }
}


#if DEBUG
#Preview("Urine Record") {
    UINavigationController(rootViewController: UrineRecordViewController())
}
#endif
