//
//  WideRectangleButton.swift
//  Altroo
//
//  Created by Raissa Parente on 06/10/25.
//

import UIKit

class WideRectangleButton: PrimaryStyleButton {
    
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
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        guard let superview = self.superview else { return }
        
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor)
        ])
    }
    
    private func setupButton() {
        backgroundColor = color
        
        setTitle(title, for: .normal)
        
        setTitleColor(.white, for: .normal)
        
        titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }
}

//#Preview {
//    WideRectangleButton(title: "O dia todo")
//}
