//
//  ArrowWideRectangleButton.swift
//  Altroo
//
//  Created by Raissa Parente on 07/10/25.
//

import UIKit

class ArrowWideRectangleButton: WideRectangleButton {
    let icon = UIImage(systemName: "chevron.right")
    
    
    override init(title: String) {
        super.init(title: title)
        
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let icon {
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: bounds.width - icon.size.width - 24, bottom: 0, right: 0)
        }
    }
    
    func setupButton() {
        guard let icon else { return }
        
        setImage(icon, for: .normal)
        
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: bounds.width - icon.size.width - 24, bottom: 0, right: 0)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -icon.size.width, bottom: 0, right: 0)
    }
}

#Preview {
    ArrowWideRectangleButton(title: "Meu perfil")
}
