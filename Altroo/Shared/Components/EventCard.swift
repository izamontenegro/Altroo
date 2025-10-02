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
        
        setupDateStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDateStack() {
        
        dayLabel = StandardLabel(
            labelText: DateFormartterHelper.weekDayFormatter(date: date),
            labelFont: .sfPro,
            labelType: .footnote,
            labelColor: .black40,
            labelWeight: .medium
        )
        
        numberLabel = StandardLabel(
            labelText: DateFormartterHelper.dayFormatter(date: date),
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
