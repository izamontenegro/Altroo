//
//  StandardSegmentedControl.swift
//  Altroo
//
//  Created by Raissa Parente on 06/10/25.
//

import UIKit

class StandardSegmentedControl: UISegmentedControl {
    
    override init(items: [Any]?) {
        super.init(items: items)
        backgroundColor = UIColor(resource: .black40)
        selectedSegmentTintColor = UIColor(resource: .teal80)
        
        translatesAutoresizingMaskIntoConstraints = false

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
