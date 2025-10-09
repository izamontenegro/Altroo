//
//  FormSectionView.swift
//  Altroo
//
//  Created by Raissa Parente on 09/10/25.
//
import UIKit

final class FormSectionView: UIStackView {
    init(title: String, content: UIView) {
        super.init(frame: .zero)
        axis = .vertical
        spacing = 4
        translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = StandardLabel(
            labelText: title,
            labelFont: .sfPro,
            labelType: .callOut,
            labelColor: .black10,
            labelWeight: .semibold
        )
        
        addArrangedSubview(titleLabel)
        addArrangedSubview(content)
    }

    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}


