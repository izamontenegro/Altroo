//
//  UrineRecordViewController.swift
//  Altroo
//
//  Created by Raissa Parente on 02/10/25.
//

import UIKit

class UrineRecordViewController: GradientNavBarViewController {
    
    let urineColors = [UIColor.urineLight, UIColor.urineLightYellow, UIColor.urineYellow, UIColor.urineOrange, UIColor.urineRed]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .pureWhite
        
        setupLayout()
    }
    
    private func configureUrineColorSection() -> UIView {
        let urineColorSectionTitle = StandardLabel(labelText: "Cor da Urina?", labelFont: .sfPro, labelType: .callOut, labelColor: .black10, labelWeight: .semibold)
        
        let urineColorRow = UIStackView()
        urineColorRow.axis = .horizontal
        urineColorRow.spacing = 18
                
        for urineColor in urineColors {
            let circleColor = UIView()
            circleColor.layer.cornerRadius = 30
            circleColor.backgroundColor = urineColor
            circleColor.layer.borderWidth = 2
            circleColor.layer.borderColor = UIColor.white70.cgColor
            
            
            NSLayoutConstraint.activate([
                circleColor.widthAnchor.constraint(equalToConstant: 60),
                circleColor.heightAnchor.constraint(equalToConstant: 60)
            ])
            
            urineColorRow.addArrangedSubview(circleColor)
        }
        
        let urineColorSection = UIStackView()
        urineColorSection.axis = .vertical
        urineColorSection.alignment = .leading
        urineColorSection.spacing = 16
        
        urineColorSection.addArrangedSubview(urineColorSectionTitle)
        urineColorSection.addArrangedSubview(urineColorRow)
        

        urineColorSection.translatesAutoresizingMaskIntoConstraints = false
        
        return urineColorSection
    }
    
    private func setupUrineCharacteristicsSection() {
        let urineCharacteristicsSectionTitle = StandardLabel(labelText: "Alguma dessas características?", labelFont: .sfPro, labelType: .callOut, labelColor: .black10, labelWeight: .semibold)
        
        let urineCharacteristicsColumn = UIStackView()
        urineCharacteristicsColumn.axis = .vertical
        urineCharacteristicsColumn.spacing = 16
        
        for urineColor in urineColors {
        
        let urineCharacteristicsSection = UIStackView()
        urineCharacteristicsSection.axis = .vertical
        urineCharacteristicsSection.spacing = 16
    }
    
    private func setupLayout() {
        let urineColorSection = configureUrineColorSection()
        view.addSubview(urineColorSection)
        
        NSLayoutConstraint.activate([
            urineColorSection.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            urineColorSection.centerYAnchor.constraint(equalTo: view.centerYAnchor),

        ])
    }
}

#Preview {
    UrineRecordViewController()
}
