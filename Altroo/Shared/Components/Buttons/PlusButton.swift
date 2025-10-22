//
//  PlusButton.swift
//  Altroo
//
//  Created by Raissa Parente on 30/09/25.
//

import UIKit

class PlusButton: UIButton {
    
    let circle = CircleView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.1) {
                self.circle.alpha = self.isHighlighted ? 0.75 : 1.0
                self.transform = self.isHighlighted ? .init(scaleX: 0.98, y: 0.98) : .identity
            }
        }
    }

    private func setupButton() {
        circle.fillColor = UIColor(resource: .teal20)
        circle.translatesAutoresizingMaskIntoConstraints = false
        
        let icon = UIImageView(image: UIImage(systemName: "plus"))
        icon.contentMode = .scaleAspectFit
        icon.tintColor = UIColor(resource: .pureWhite)
        icon.translatesAutoresizingMaskIntoConstraints = false
                
        addSubview(circle)
        circle.addSubview(icon)
        
        circle.isUserInteractionEnabled = false

        NSLayoutConstraint.activate([
            circle.topAnchor.constraint(equalTo: self.topAnchor),
            circle.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            circle.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            circle.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            icon.centerXAnchor.constraint(equalTo: circle.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: circle.centerYAnchor),
            icon.widthAnchor.constraint(equalTo: circle.widthAnchor, multiplier: 0.65),
            icon.heightAnchor.constraint(equalTo: icon.widthAnchor)
        ])
    }
}

#Preview {
    PlusButton()
}
