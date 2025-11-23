//
//  RepeatDaysRow.swift
//  Altroo
//
//  Created by Raissa Parente on 09/10/25.
//
import UIKit

final class RepeatDaysRow: UIStackView {
    var didSelectDay: ((Locale.Weekday, Bool) -> Void)?
    private var dayButtons: [PrimaryStyleButton] = []
    
    
    init(selectedDays: [Locale.Weekday] = []) {
        super.init(frame: .zero)
        axis = .horizontal
        distribution = .equalCentering
        translatesAutoresizingMaskIntoConstraints = false
        
        for day in Locale.Weekday.allWeekDays {
            let symbol = day.localizedSymbol(style: .veryShort)
            let button = PrimaryStyleButton(title: symbol.uppercased())
            button.backgroundColor = selectedDays.contains(day) ? .teal20 : .black40
            button.associatedData = day
            button.addTarget(self, action: #selector(didTapDay(_:)), for: .touchUpInside)
            addArrangedSubview(button)
            dayButtons.append(button)
        }
    }

    @objc private func didTapDay(_ sender: PrimaryStyleButton) {
        guard let day = sender.associatedData as? Locale.Weekday else { return }
        let isSelected = sender.backgroundColor == .teal20
        sender.backgroundColor = isSelected ? .black40 : .teal20
        didSelectDay?(day, !isSelected)
    }
    
    func updateSelectedDays(_ days: [Locale.Weekday]) {
        for button in dayButtons {
            guard let day = button.associatedData as? Locale.Weekday else { continue }
            button.backgroundColor = days.contains(day) ? .teal20 : .black40
        }
    }


    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
