//
//  StandardSegmentedControl.swift
//  Altroo
//
//  Created by Raissa Parente on 06/10/25.
//

import UIKit

class StandardSegmentedControl: UIView {
    
    private let segmentedControl = UISegmentedControl()
    
    var items: [String]
    
    var selectedColor: UIColor
    var backgroundColorNormal: UIColor
    var selectedFontColor: UIColor
    var unselectedFontColor: UIColor
    
    var cornerRadius: CGFloat
    var height: CGFloat
    var width: CGFloat
    
    init(items: [String],
         width: CGFloat,
         height: CGFloat,
         backgroundColor: UIColor,
         selectedColor: UIColor,
         selectedFontColor: UIColor,
         unselectedFontColor: UIColor,
         cornerRadius: CGFloat) {
        
        self.items = items
        self.width = width
        self.height = height
        self.backgroundColorNormal = backgroundColor
        self.selectedColor = selectedColor
        self.selectedFontColor = selectedFontColor
        self.unselectedFontColor = unselectedFontColor
        self.cornerRadius = cornerRadius
        
        super.init(frame: .zero)
        
        setupSegmentedControl()
        styleSegmentedControl()
        layoutSegmentedControl()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSegmentedControl() {
        for (index, title) in items.enumerated() {
            segmentedControl.insertSegment(withTitle: title, at: index, animated: false)
        }
        segmentedControl.selectedSegmentIndex = 0
    }
    
    private func styleSegmentedControl() {
        segmentedControl.backgroundColor = backgroundColorNormal
        segmentedControl.selectedSegmentTintColor = selectedColor
        
        let normalTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: unselectedFontColor
        ]
        
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: selectedFontColor
        ]
        
        segmentedControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        
        segmentedControl.layer.cornerRadius = cornerRadius
        segmentedControl.layer.masksToBounds = true
    }
    
    private func layoutSegmentedControl() {
        addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            segmentedControl.widthAnchor.constraint(equalToConstant: width),
            segmentedControl.heightAnchor.constraint(equalToConstant: height),
            segmentedControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            segmentedControl.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    var selectedIndex: Int {
        get { segmentedControl.selectedSegmentIndex }
        set { segmentedControl.selectedSegmentIndex = newValue }
    }
    
    var selectedTitle: String? {
        return segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)
    }
}

import SwiftUI

private struct SegmentedControlPreviewWrapper: UIViewRepresentable {
    func updateUIView(_ uiView: StandardSegmentedControl, context: Context) { }
    
    func makeUIView(context: Context) -> StandardSegmentedControl {
        return StandardSegmentedControl(
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
    
//    func makeUIView(context: Context) -> StandardSegmentedControl {
//        return StandardSegmentedControl(
//            items: ["F", "M"],
//            width: 113,
//            height: 35,
//            backgroundColor: UIColor(resource: .white70),
//            selectedColor: UIColor(resource: .teal20),
//            selectedFontColor: UIColor(resource: .pureWhite),
//            unselectedFontColor: UIColor(resource: .black30),
//            cornerRadius: 8
//        )
//    }
}

#Preview {
    SegmentedControlPreviewWrapper()
        .padding()
}
