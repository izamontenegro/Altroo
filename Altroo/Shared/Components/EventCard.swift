//
//  EventCard.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 02/10/25.
//

import UIKit

class EventCard: InnerShadowView {
    let date: Date
    
    private let dayLabel = UILabel()
    private let numberLabel = UILabel()
    
    init(frame: CGRect = .zero, date: Date) {
        self.date = date
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
        
        dayLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        dayLabel.textColor = .systemGray
        dayLabel.text = weekdayFormatter.string(from: date).uppercased()
        
       
        numberLabel.font = .systemFont(ofSize: 36, weight: .bold)
        numberLabel.textColor = .darkGray
        numberLabel.text = dayFormatter.string(from: date)
        
        // Stack vertical
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
    EventCard(date: Date())
}
