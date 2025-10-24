//
//  UIScrollView+Extensions.swift
//  Altroo
//
//  Created by Raissa Parente on 20/10/25.
//
import UIKit

extension UIScrollView {
    enum ScrollDirection {
        case vertical
        case horizontal
    }

    static func make(direction: ScrollDirection = .vertical) -> UIScrollView {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false

        switch direction {
        case .vertical:
            scroll.alwaysBounceVertical = true
            scroll.showsVerticalScrollIndicator = true
            scroll.alwaysBounceHorizontal = false
            scroll.showsHorizontalScrollIndicator = false
        case .horizontal:
            scroll.alwaysBounceHorizontal = true
            scroll.showsHorizontalScrollIndicator = true
            scroll.alwaysBounceVertical = false
            scroll.showsVerticalScrollIndicator = false
        }

        return scroll
    }
}
