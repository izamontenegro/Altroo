//
//  StandardToggle.swift
//  Altroo
//
//  Created by Raissa Parente on 06/10/25.
//
import UIKit

class StandardToggle: UISwitch {
    init() {
        super.init(frame: .zero)
        onTintColor = .teal20
        thumbTintColor = .teal20
        backgroundColor = .white80
        
        translatesAutoresizingMaskIntoConstraints = false

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
