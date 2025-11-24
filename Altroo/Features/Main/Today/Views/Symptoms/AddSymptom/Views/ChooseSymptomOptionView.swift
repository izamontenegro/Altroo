//
//  ChooseSymptomOptionView.swift
//  Altroo
//
//  Created by Raissa Parente on 24/11/25.
//

import UIKit
import Combine

final class ChooseSymptomOptionView: UIView {
    private var cancellables = Set<AnyCancellable>()


    init() {
        super.init(frame: .zero)

    }

    required init?(coder: NSCoder) { fatalError() }


    func makeSection(for category: SymptomTypes) {
        let title = StandardLabel(labelText: category.displayText,
                                  labelFont: .sfPro,
                                  labelType: .body,
                                  labelColor: .blue10,
                                  labelWeight: .semibold)
        let rect = UIView()
        rect.backgroundColor = .blue80
        rect.layer.cornerRadius = 4
        rect.addSubview(title)
        
        var buttons: [UIView] = []
        for incident in category.allTypes {
            let button = OutlineRectangleButton(title: incident)
            buttons.append(button)
        }
//        let buttonsView = 
    }

}

