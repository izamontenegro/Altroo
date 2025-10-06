//
//  StandardConfirmationButton.swift
//  Altroo
//
//  Created by Raissa Parente on 06/10/25.
//

import UIKit


final class StandardConfirmationButton: PrimaryStyleButton {
    var title: String
    
    init(title: String) {
        self.title = title
        super.init()
        
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupButton() {
        setTitle(title, for: .normal)
        
        setTitleColor(.white, for: .normal)
        
        layer.cornerRadius = 26
        
        contentEdgeInsets = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
        
        titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

#Preview {
    StandardConfirmationButton(title: "Adicionar")
}
