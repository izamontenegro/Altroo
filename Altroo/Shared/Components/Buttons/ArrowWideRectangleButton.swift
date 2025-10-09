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
        
        guard let titleLabel = titleLabel, let imageView = imageView else { return }
        
        let horizontalPadding: CGFloat = 16
        let spacingBetweenTitleAndIcon: CGFloat = 8
        
        let imageWidth = imageView.intrinsicContentSize.width
        let titleWidth = titleLabel.intrinsicContentSize.width
        
        // Title on the left
        titleLabel.frame.origin.x = horizontalPadding
        titleLabel.frame.origin.y = (bounds.height - titleLabel.frame.height) / 2
        
        // Title on the right
        imageView.frame.origin.x = bounds.width - imageWidth - horizontalPadding
        imageView.frame.origin.y = (bounds.height - imageView.frame.height) / 2
        
        // Avoids text overlapping with the icon
        let maxTitleWidth = bounds.width - imageWidth - spacingBetweenTitleAndIcon - horizontalPadding * 2
        titleLabel.frame.size.width = min(titleWidth, maxTitleWidth)
    }
    
    private func setupButton() {
        guard let icon = icon?.withRenderingMode(.alwaysTemplate) else { return }
        
        setImage(icon, for: .normal)
        tintColor = .pureWhite
        setTitleColor(.pureWhite, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        
        // Base alignment and spacing
        contentHorizontalAlignment = .left
        contentEdgeInsets = UIEdgeInsets(top: 10,
                                         left: 16,
                                         bottom: 10,
                                         right: 16)
        
        // Resets image/title insets (layoutSubviews will reposition)
        titleEdgeInsets = .zero
        imageEdgeInsets = .zero
    }
}

#Preview {
    ArrowWideRectangleButton(title: "default")
}
