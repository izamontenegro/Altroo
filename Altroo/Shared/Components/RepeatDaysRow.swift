//
//  RepeatDaysRow.swift
//  Altroo
//
//  Created by Raissa Parente on 09/10/25.
//
import UIKit

final class RepeatDaysRow: UIStackView {
    var didSelectDay: ((Locale.Weekday, Bool) -> Void)?
    
    init(selectedDays: [Locale.Weekday] = []) {
        super.init(frame: .zero)
        axis = .horizontal
        distribution = .equalCentering
        translatesAutoresizingMaskIntoConstraints = false
        
        for day in Locale.Weekday.allCases {
            let button = PrimaryStyleButton(title: day.rawValue.prefix(1).uppercased())
            button.backgroundColor = selectedDays.contains(day) ? .teal20 : .black40
            button.associatedData = day
            button.addTarget(self, action: #selector(didTapDay(_:)), for: .touchUpInside)
            addArrangedSubview(button)
        }
    }

    @objc private func didTapDay(_ sender: PrimaryStyleButton) {
        guard let day = sender.associatedData as? Locale.Weekday else { return }
        let isSelected = sender.backgroundColor == .teal20
        sender.backgroundColor = isSelected ? .black40 : .teal20
        didSelectDay?(day, !isSelected)
    }

    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
