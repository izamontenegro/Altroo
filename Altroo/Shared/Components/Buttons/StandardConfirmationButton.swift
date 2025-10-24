//
//  StandardConfirmationButton.swift
//  Altroo
//
//  Created by Raissa Parente on 06/10/25.
//

import UIKit

final class StandardConfirmationButton: PrimaryStyleButton {
    
    var title: String
    private let titleLabelCustom = StandardLabel(
        labelText: "",
        labelFont: .sfPro,
        labelType: .title2,
        labelColor: .pureWhite,
        labelWeight: .semibold
    )
    
    init(title: String) {
        self.title = title
        super.init()
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupButton() {
        setTitle(nil, for: .normal)
        titleLabelCustom.updateLabelText(title)
        titleLabelCustom.textAlignment = .center
        
        addSubview(titleLabelCustom)
        titleLabelCustom.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabelCustom.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabelCustom.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            widthAnchor.constraint(equalToConstant: 230),
            heightAnchor.constraint(equalToConstant: 46)
        ])
        
        layer.cornerRadius = 22
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 64,
                                         bottom: 8, right: 64)
        translatesAutoresizingMaskIntoConstraints = false
    }
    // MARK: - Public funcs
    func updateTitle(_ title: String) {
        titleLabelCustom.updateLabelText(title)
    }
}
//
//#Preview {
//    StandardConfirmationButton(title: "Adicionar")
//}
