//
//  StringExtensions.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 14/10/25.
//
import UIKit

public extension String {
    func onlyDigits() -> String {
        filter(\.isNumber)
    }
    
    var lowerTrimmed: String { trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
}

public extension Double {
    var clean: String {
        let s = String(format: "%.2f", self)
        return s.replacingOccurrences(of: ".", with: ",")
    }
}

public extension UIColor {
    var hexString: String {
        guard let components = cgColor.components, components.count >= 3 else { return "#000000" }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        return String(format: "#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
    }

    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}
