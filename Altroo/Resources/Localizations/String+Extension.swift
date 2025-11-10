//
//  String+Extension.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 09/11/25.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }

    func localizedFormat(_ arguments: CVarArg...) -> String {
        String(format: self.localized, arguments: arguments)
    }
}
