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
    
    init(title: String, info: String) {
        self.title = title
        self.info = info
        
        super.init(frame: .zero)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        self.backgroundColor = .blue80
        self.layer.cornerRadius = 8
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = StandardLabel(labelText: title, labelFont: .sfPro, labelType: .title3, labelColor: .black40)
        let infoLabel = StandardLabel(labelText: info, labelFont: .sfPro, labelType: .title3, labelColor: .black10)
        
        addSubview(titleLabel)
        addSubview(infoLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor,  constant: 6),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -6),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            infoLabel.topAnchor.constraint(equalTo: self.topAnchor,  constant: 6),
            infoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -6),
            infoLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            ])
    }
    
}

#Preview {
    InfoRowView(title: "Nome", info: "Dar banho")
}
