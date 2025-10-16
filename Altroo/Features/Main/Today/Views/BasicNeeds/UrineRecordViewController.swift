//
//  UrineRecordViewController.swift
//  Altroo
//
//  Created by Raissa Parente on 02/10/25.
//

import UIKit

class UrineRecordViewController: GradientNavBarViewController {
    
    let urineColors = [UIColor.urineLight, UIColor.urineLightYellow, UIColor.urineYellow, UIColor.urineOrange, UIColor.urineRed]

    let viewLabel: UILabel = {
        let label = UILabel()
        label.text = "Record Urine View"
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .yellow
        
        view.addSubview(viewLabel)

        setupLayout()
        
        NSLayoutConstraint.activate([
            viewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func configureUrineColorSection() -> UIView {
        let urineColorSectionTitle = StandardLabel(labelText: "Cor da Urina?", labelFont: .sfPro, labelType: .callOut, labelColor: .black10, labelWeight: .semibold)
        
        let urineColorRow = UIStackView()
        urineColorRow.axis = .horizontal
        urineColorRow.spacing = 18
        
        for urineColor in urineColors {
            let circleColor = UIView()
            circleColor.layer.cornerRadius = 30
            circleColor.tintColor = urineColor
            
            urineColorRow.addArrangedSubview(circleColor)
        }
        
        let urineColorSection = UIStackView()
        urineColorSection.axis = .vertical
        urineColorSection.spacing = 16
        
        urineColorSection.addArrangedSubview(urineColorSectionTitle)
        urineColorSection.addArrangedSubview(urineColorRow)

        return urineColorSection
    }
    
    private func setupLayout() {
        
    }
}

#Preview {
    UrineRecordViewController()
}
