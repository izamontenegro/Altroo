//
//  StandardSegmentedControl.swift
//  Altroo
//
//  Created by Raissa Parente on 06/10/25.
//

import UIKit

class StandardSegmentedControl: UISegmentedControl {
    private var itemsList: [String]
    
    var selectedColor: UIColor
    var backgroundColorNormal: UIColor
    var selectedFontColor: UIColor
    var unselectedFontColor: UIColor
    private var cornerRadius: CGFloat
    
    init(items: [String],
         height: CGFloat,
         backgroundColor: UIColor,
         selectedColor: UIColor,
         selectedFontColor: UIColor,
         unselectedFontColor: UIColor,
         cornerRadius: CGFloat) {
        
        self.itemsList = items
        self.backgroundColorNormal = backgroundColor
        self.selectedColor = selectedColor
        self.selectedFontColor = selectedFontColor
        self.unselectedFontColor = unselectedFontColor
        self.cornerRadius = cornerRadius
        
        super.init(items: items)
        
        setupStyle(height: height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(items: [String]) {
        self.init(
            items: items,
            height: 35,
            backgroundColor: .pureWhite,
            selectedColor: .blue30,
            selectedFontColor: .pureWhite,
            unselectedFontColor: .black30,
            cornerRadius: 8
        )
    }
    
    private func setupStyle(height: CGFloat) {
        selectedSegmentIndex = 0
        
        backgroundColor = .pureWhite
        isOpaque = false
        selectedSegmentTintColor = selectedColor
        
        let normalTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: unselectedFontColor
        ]
        
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: selectedFontColor
        ]
        
        setTitleTextAttributes(normalTextAttributes, for: .normal)
        setTitleTextAttributes(selectedTextAttributes, for: .selected)
        
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    var selectedTitle: String? {
        titleForSegment(at: selectedSegmentIndex)
    }
}

import SwiftUI

private struct SegmentedControlPreviewWrapper: UIViewRepresentable {
    func updateUIView(_ uiView: StandardSegmentedControl, context: Context) { }
    
    func makeUIView(context: Context) -> StandardSegmentedControl {
        StandardSegmentedControl(
            items: ["Diário", "Mensal"],
            height: 35,
            backgroundColor: UIColor(resource: .white80),
            selectedColor: UIColor(resource: .blue30),
            selectedFontColor: UIColor(resource: .pureWhite),
            unselectedFontColor: UIColor(resource: .blue10),
            cornerRadius: 8
        )
    }
}

extension UISegmentedControl {
    func applyWhiteBackgroundColor() {
        // for remove bottom shadow of selected element
        self.selectedSegmentTintColor = selectedSegmentTintColor?.withAlphaComponent(0.99)
        if #available(iOS 13.0, *) {
            //just to be sure it is full loaded
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                guard let self = self else {
                    return
                }
                for i in 0 ..< (self.numberOfSegments)  {
                    let backgroundSegmentView = self.subviews[i]
                    //it is not enogh changing the background color. It has some kind of shadow layer
                    backgroundSegmentView.isHidden = true
                }
            }
        }
    }
}
