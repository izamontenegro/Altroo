//
//  ArrowWideRectangleButton.swift
//  Altroo
//
//  Created by Raissa Parente on 07/10/25.
//

import UIKit

class ArrowWideRectangleButton: WideRectangleButton {
    
    let icon = UIImage(systemName: "chevron.right")
    private var innerShadowView: InnerShadowView?
    
    override init(title: String) {
        super.init(title: title)
        setupButton()
        setupInnerShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        innerShadowView?.frame = bounds
        
        guard let titleLabel = titleLabel, let imageView = imageView else { return }
        
        let horizontalPadding: CGFloat = 16
        let spacingBetweenTitleAndIcon: CGFloat = 8
        
        let imageWidth = imageView.intrinsicContentSize.width
        let titleWidth = titleLabel.intrinsicContentSize.width
        
        titleLabel.frame.origin.x = horizontalPadding
        titleLabel.frame.origin.y = (bounds.height - titleLabel.frame.height) / 2
        
        imageView.frame.origin.x = bounds.width - imageWidth - horizontalPadding
        imageView.frame.origin.y = (bounds.height - imageView.frame.height) / 2
        
        let maxTitleWidth = bounds.width - imageWidth - spacingBetweenTitleAndIcon - horizontalPadding * 2
        titleLabel.frame.size.width = min(titleWidth, maxTitleWidth)
    }
    
    private func setupButton() {
        guard let icon = icon?.withRenderingMode(.alwaysTemplate) else { return }
        
        setImage(icon, for: .normal)
        tintColor = .white
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        
        contentHorizontalAlignment = .left
        contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        titleEdgeInsets = .zero
        imageEdgeInsets = .zero
        
        layer.cornerRadius = 6
        clipsToBounds = true
    }
    
    private func setupInnerShadow() {
        let shadow = InnerShadowView(frame: bounds, color: UIColor.teal0, opacity: 0.20)
        shadow.isUserInteractionEnabled = false
        shadow.layer.cornerRadius = layer.cornerRadius
        addSubview(shadow)
        innerShadowView = shadow
    }
}

#Preview {
    ArrowWideRectangleButton(title: "default")
}
