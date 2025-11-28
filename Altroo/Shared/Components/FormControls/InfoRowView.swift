//
//  InfoRowView.swift
//  Altroo
//
//  Created by Raissa Parente on 07/10/25.
//

import UIKit

class InfoRowView: UIView {
    
    var title: String
    var info: String
    var isLate: Bool
    
    init(title: String, info: String, isLate: Bool = false) {
        self.title = title
        self.info = info
        self.isLate = isLate
        
        super.init(frame: .zero)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.backgroundColor = .blue80
        self.backgroundColor = isLate ? .red80 : .blue80
        self.layer.cornerRadius = 8
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = StandardLabel(labelText: title,
                                       labelFont: .sfPro,
                                       labelType: .callOut,
                                       labelColor: isLate ? .red20 : .black40)

        let infoLabel = StandardLabel(labelText: info,
                                      labelFont: .sfPro,
                                      labelType: .callOut,
                                      labelColor: .black10,
                                      labelWeight: .medium)
        
        infoLabel.numberOfLines = 0
        
        addSubview(titleLabel)
        addSubview(infoLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor,  constant: 8),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -8),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            infoLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            infoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            infoLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            infoLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor)
        ])
        
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        infoLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        if isLate {
            let lateLabel = StandardLabel(labelText: "Em atraso",
                                          labelFont: .sfPro,
                                          labelType: .callOut,
                                          labelColor: .red20,
                                          labelWeight: .medium)

            addSubview(lateLabel)

            NSLayoutConstraint.activate([
                lateLabel.topAnchor.constraint(equalTo: self.topAnchor,  constant: 6),
                lateLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -6),
                lateLabel.trailingAnchor.constraint(equalTo: infoLabel.leadingAnchor, constant: -16),
            ])
        }
    }
}

//#Preview {
//    InfoRowView(title: "Nome", info: "Dar banho Dar banho")
//}
