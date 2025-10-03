//
//  EventCard.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 02/10/25.
//
import UIKit

class mockEvents {
    var name: String
    var startTime: Date?
    var endTime: Date?
    var startDate: Date
    var endDate: Date?
    
    init(name: String, startTime: Date?, endTime: Date?, startDate: Date, endDate: Date?) {
        self.name = name
        self.startTime = startTime
        self.endTime = endTime
        self.startDate = startDate
        self.endDate = endDate
    }
}

class EventCard: InnerShadowView {
    let date: Date
    var dayEvents: [mockEvents]
    
    private var dayLabel: StandardLabel!
    private var numberLabel: StandardLabel!
    
    init(frame: CGRect = .zero, date: Date, dayEvents: [mockEvents]) {
        self.date = date
        self.dayEvents = dayEvents
        super.init(frame: frame, color: .white)
        
        setupCardLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeDateStack() -> UIStackView {
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
        
        let dateStack = UIStackView(arrangedSubviews: [dayLabel, numberLabel])
        dateStack.axis = .vertical
        dateStack.alignment = .leading
        dateStack.spacing = 0
        
        return dateStack
    }
    
    private func makeEventStack() -> UIStackView {
        let eventsStack = UIStackView()
        eventsStack.axis = .vertical
        eventsStack.spacing = 3
        eventsStack.distribution = .fillEqually
        
        
        for (index, event) in dayEvents.enumerated() {
            let eventView = makeEventView(event: event, index: index)
            eventsStack.addArrangedSubview(eventView)
        }
        
        return eventsStack
    }
    
     private func setupCardLayout() {
        let mainStack = UIStackView(arrangedSubviews: [makeDateStack(), makeEventStack()])
        mainStack.axis = .horizontal
        mainStack.alignment = .top
        mainStack.spacing = 88
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
        
        
        backgroundColor = .systemRed
    }
    
    private func makeEventView(event: mockEvents, index: Int) -> UIView {
        let eventView = UIView()
        eventView.layer.cornerRadius = 8
        eventView.backgroundColor = getEventColor(forIndex: index)
        eventView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = StandardLabel(labelText: event.name, labelFont: .sfPro, labelType: .subHeadline, labelColor: .pureWhite, labelWeight: .semibold)
        titleLabel.numberOfLines = 1

        let eventViewStack = UIStackView()
        eventViewStack.axis = .vertical
        eventViewStack.spacing = 0
        eventViewStack.translatesAutoresizingMaskIntoConstraints = false
        
        eventViewStack.addArrangedSubview(titleLabel)
        eventViewStack.addArrangedSubview(makeTimeLabel(event: event))

        eventView.addSubview(eventViewStack)
        
        NSLayoutConstraint.activate([
            eventViewStack.topAnchor.constraint(equalTo: eventView.topAnchor, constant: 4),
            eventViewStack.leadingAnchor.constraint(equalTo: eventView.leadingAnchor, constant: 8),
            eventViewStack.trailingAnchor.constraint(equalTo: eventView.trailingAnchor, constant: -8),
            eventViewStack.bottomAnchor.constraint(equalTo: eventView.bottomAnchor, constant: -8)
        ])

        return eventView
    }

    private func getEventColor(forIndex index: Int) -> UIColor {
        switch index {
        case 0:
            return .blue40
        case 1:
            return .teal20
        case 2:
            return .purple20
        default:
            return .blue80
        }
    }
    
    private func makeTimeLabel(event: mockEvents) -> UIView {
        if let start = event.startTime, let end = event.endTime {
            let timeLabelText = "\(DateFormartterHelper.hourFormatter(date: start)) - \(DateFormartterHelper.hourFormatter(date: end))"
            
            let timeLabel = StandardLabel(labelText: timeLabelText, labelFont: .sfPro, labelType: .subHeadline, labelColor: .pureWhite, labelWeight: .regular)
        
            return timeLabel
            
        } else if let start = event.startTime {
            
            let timeLabelText = DateFormartterHelper.hourFormatter(date: start)
            
            let timeLabel = StandardLabel(labelText: timeLabelText, labelFont: .sfPro, labelType: .subHeadline, labelColor: .pureWhite, labelWeight: .regular)
        
            return timeLabel
        } else if let end = event.endTime {
            let timeLabelText = "até \(DateFormartterHelper.hourFormatter(date: end))"
            
            let timeLabel = StandardLabel(labelText: timeLabelText, labelFont: .sfPro, labelType: .subHeadline, labelColor: .pureWhite, labelWeight: .regular)
            
            return timeLabel
        } else {
            let emptyLabel = UILabel()
            emptyLabel.text = ""
            
            return emptyLabel
        }
    }

}

class EventCardPreview: UIViewController {
    let card = EventCard(date: Date(), dayEvents: [
        mockEvents(name: "Ortopedista", startTime: nil, endTime: nil, startDate: Date(), endDate: nil),
        mockEvents(name: "Eat some burguers", startTime: nil, endTime: Date(), startDate: Date(), endDate: nil),
        mockEvents(name: "Eat some burguers", startTime: Date(), endTime: Date(), startDate: Date(), endDate: nil)
    ])


    override func viewDidLoad() {
        view.backgroundColor = .blue80

        view.addSubview(card)

        card.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            card.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            card.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            card.leadingAnchor.constraint(equalTo: view.leadingAnchor),

        ])

    }
}


#Preview {
    
    EventCardPreview()
//    EventCard(
//        date: Date(),
//        dayEvents: [
//            mockEvents(name: "Ortopedista", startTime: nil, endTime: nil, startDate: Date(), endDate: nil),
//            mockEvents(name: "Eat some burguers", startTime: nil, endTime: Date(), startDate: Date(), endDate: nil),
//            mockEvents(name: "Eat some burguers", startTime: Date(), endTime: Date(), startDate: Date(), endDate: nil)
//        ]
//    )
}
