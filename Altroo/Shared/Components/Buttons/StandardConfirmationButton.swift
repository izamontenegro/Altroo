//
//  StandardConfirmationButton.swift
//  Altroo
//
//  Created by Raissa Parente on 06/10/25.
//

import UIKit


final class StandardConfirmationButton: UIButton {
    init(title: String, color: UIColor) {
        super.init(frame: .zero)
        
        setupButton(title: title, color: color)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton(title: "Default Button", color: .systemBlue) // Fallback setup
    }


    private func setupButton(title: String, color: UIColor) {
        backgroundColor = color

        setTitle(title, for: .normal)
        
        setTitleColor(.white, for: .normal)
        
        layer.cornerRadius = 12
        layer.masksToBounds = true
        
            titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        contentEdgeInsets = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
    }
}

#Preview {
    StandardConfirmationButton(title: "Adicionar", color: UIColor(resource: .teal40))
}
