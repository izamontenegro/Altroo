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
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupButton() {
        setTitle(title, for: .normal)
        
        setTitleColor(.white, for: .normal)
        
        layer.cornerRadius = 22
        
        contentEdgeInsets = UIEdgeInsets(top: 8,
                                         left: 64,
                                         bottom: 8,
                                         right: 64)
        
        titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

#Preview {
    StandardConfirmationButton(title: "Adicionar")
}
