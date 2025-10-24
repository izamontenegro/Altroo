//
//  StandardSegmentedControl.swift
//  Altroo
//
//  Created by Raissa Parente on 06/10/25.
//

import UIKit

class StandardSegmentedControl: UISegmentedControl {
    
    private var itemsList: [String]
    
    private var selectedColor: UIColor
    private var backgroundColorNormal: UIColor
    private var selectedFontColor: UIColor
    private var unselectedFontColor: UIColor
    private var cornerRadius: CGFloat
    
    init(items: [String],
         width: CGFloat,
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
        
        setupStyle(width: width, height: height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(items: [String]) {
        self.init(
            items: items,
            width: 113,
            height: 35,
            backgroundColor: .pureWhite,
            selectedColor: .teal20,
            selectedFontColor: .pureWhite,
            unselectedFontColor: .black30,
            cornerRadius: 8
        )
    }
    
    private func setupStyle(width: CGFloat, height: CGFloat) {
        selectedSegmentIndex = 0
        
        backgroundColor = backgroundColorNormal
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
            widthAnchor.constraint(equalToConstant: width),
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
            width: 241,
            height: 35,
            backgroundColor: UIColor(resource: .white80),
            selectedColor: UIColor(resource: .blue30),
            selectedFontColor: UIColor(resource: .pureWhite),
            unselectedFontColor: UIColor(resource: .blue10),
            cornerRadius: 8
        )
    }
}

//#Preview {
//    SegmentedControlPreviewWrapper()
//        .padding()
//}
