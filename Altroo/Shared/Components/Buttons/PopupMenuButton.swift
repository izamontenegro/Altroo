//
//  DropdownMenuButton.swift
//  Altroo
//
//  Created by Raissa Parente on 06/10/25.
//

import UIKit

final class PopupMenuButton: PrimaryStyleButton {
    
    var title: String
    let icon = UIImage(systemName: "chevron.up.chevron.down")
        
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
        
         if let icon = icon, let titleLabel = self.titleLabel {
             let spacing: CGFloat = 8
             
             self.titleEdgeInsets = UIEdgeInsets(top: 0,
                                                 left: -icon.size.width - spacing / 2,
                                                 bottom: 0,
                                                 right: icon.size.width + spacing / 2)
             self.imageEdgeInsets = UIEdgeInsets(top: 0,
                                                 left: titleLabel.frame.size.width + spacing / 2,
                                                 bottom: 0,
                                                 right: -titleLabel.frame.size.width - spacing / 2)
         }
     }
    
    private func setupButton() {
        backgroundColor = color
        
        //text
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        // icon
        if let icon = icon?.withRenderingMode(.alwaysTemplate) {
            setImage(icon, for: .normal)
            tintColor = .white // change the icon color here
        }
        
        if let icon = icon {
            setImage(icon, for: .normal)
            
            let spacing: CGFloat = 8
            
            self.titleEdgeInsets = UIEdgeInsets(top: 0,
                                                left: -icon.size.width - spacing / 2,
                                                bottom: 0,
                                                right: icon.size.width + spacing / 2)
            
            self.imageEdgeInsets = UIEdgeInsets(top: 0,
                                                left: self.titleLabel!.frame.size.width + spacing / 2,
                                                bottom: 0,
                                                right: -self.titleLabel!.frame.size.width - spacing / 2)
            
            let currentInsets = self.contentEdgeInsets
            self.contentEdgeInsets = UIEdgeInsets(top: currentInsets.top,
                                                  left: currentInsets.left + 16,
                                                  bottom: currentInsets.bottom,
                                                  right: currentInsets.right + icon.size.width)
        }
    }
}

#Preview {
    PopupMenuButton(title: "Filha")
}
