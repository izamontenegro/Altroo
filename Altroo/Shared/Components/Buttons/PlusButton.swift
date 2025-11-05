//
//  PlusButton.swift
//  Altroo
//
//  Created by Raissa Parente on 30/09/25.
//

import UIKit

class PlusButton: UIButton {
    
    let circle = CircleView()
    var onTap: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
        setupActions()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
        setupActions()
    }
    
    private func setupActions() {
        addTarget(self, action: #selector(touchDown), for: .touchDown)
        addTarget(self, action: #selector(touchUpInsideAction), for: .touchUpInside)
        addTarget(self, action: #selector(cancelTap), for: [.touchDragExit, .touchCancel, .touchUpOutside])
    }

    @objc private func touchDown() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseIn], animations: {
            self.circle.alpha = 0.85
            self.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        })
    }

    @objc private func touchUpInsideAction() {
        UIView.animate(withDuration: 0.22,
                       delay: 0,
                       usingSpringWithDamping: 0.55,
                       initialSpringVelocity: 4,
                       options: [.curveEaseOut],
                       animations: {
            self.circle.alpha = 1
            self.transform = .identity
        }, completion: { _ in
            self.onTap?()
        })
    }

    @objc private func cancelTap() {
        UIView.animate(withDuration: 0.12) {
            self.circle.alpha = 1
            self.transform = .identity
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

//#Preview {
//    PlusButton()
//}
