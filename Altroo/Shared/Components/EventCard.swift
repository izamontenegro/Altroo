//
//  EventCard.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 02/10/25.
//
import UIKit
import CoreData

class EventCard: InnerShadowView {
    let date: Date
    var dayEvents: [CareRecipientEvents]
    
    
    private var dayLabel: StandardLabel!
    private var numberLabel: StandardLabel!
    
    init(frame: CGRect = .zero, date: Date, dayEvents: [CareRecipientEvents]) {
        self.date = date
        self.dayEvents = dayEvents

        super.init(frame: frame, color: .blue70)
        
        setupDate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDate() {
        let weekdayFormatter = DateFormatter()
        weekdayFormatter.locale = Locale(identifier: "pt_BR")
        weekdayFormatter.dateFormat = "EEE"
        
        let dayFormatter = DateFormatter()
        dayFormatter.locale = Locale(identifier: "pt_BR")
        dayFormatter.dateFormat = "d"
        
        dayLabel = StandardLabel(
            labelText: weekdayFormatter.string(from: date).uppercased(),
            labelFont: .sfPro,
            labelType: .footnote,
            labelColor: .black40,
            labelWeight: .medium
        )
        
        numberLabel = StandardLabel(
            labelText: dayFormatter.string(from: date),
            labelFont: .sfPro,
            labelType: .largeTitle,
            labelColor: .black20,
            labelWeight: .bold
        )
        
        let stack = UIStackView(arrangedSubviews: [dayLabel, numberLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
        ])
    }
    
}

#Preview {
    EventCard(
        date: Date(),
        dayEvents: []
    )
}
