//
//  TaskCard.swift
//  Altroo
//
//  Created by Raissa Parente on 07/10/25.
//

import UIKit

class TaskCard: InnerShadowView {
    let task: MockTask
    
    var cardTapAction: (() -> Void)?

    let titleLabel = StandardLabel(labelText: "", labelFont: .sfPro, labelType: .callOut, labelColor: .black, labelWeight: .medium)
    
    var wasChecked = false
    
    let checkButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(resource: .white60)
        button.layer.cornerRadius = 5
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let checkIcon: UIImageView = {
        let icon = UIImageView(image: UIImage(systemName: "checkmark"))
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.tintColor = .white
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    
    init(task: MockTask) {
        self.task = task
        super.init(frame: .zero, color: .blue80)
        setupUI()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 10
        
        loadData()
        
        let timetag = makeTimeTag()
        timetag.translatesAutoresizingMaskIntoConstraints = false 
        addSubview(titleLabel)
        addSubview(checkButton)
        addSubview(timetag)
        
        checkButton.addTarget(self, action: #selector(didTapCheckButton), for: .touchUpInside)
        setupTapGesture()
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            
            timetag.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            timetag.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            timetag.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            
            checkButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            checkButton.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            checkButton.heightAnchor.constraint(equalToConstant: 18),
            checkButton.widthAnchor.constraint(equalTo: checkButton.heightAnchor),

        ])
    }
    
    func makeTimeTag() -> UIView {
        let timeLabel = StandardLabel(labelText: "\(task.time!.formatted(date: .omitted, time: .shortened))", labelFont: .sfPro, labelType: .subHeadline, labelColor: .teal0, labelWeight: .regular)
        let icon = UIImageView(image: UIImage(systemName: "alarm.fill"))
        icon.tintColor = UIColor(resource: .teal10)
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        let container = UIView()
        container.backgroundColor = UIColor(resource: .teal80)
        container.layer.cornerRadius = 4
        container.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(icon)
        container.addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 5),
            icon.topAnchor.constraint(equalTo: container.topAnchor, constant: 5),
            icon.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -5),
            
            timeLabel.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 5),
            timeLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 5),
            timeLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -5),
            timeLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -5),
        ])
        
        return container
    }
    
    func reloadButton() {
        if !wasChecked {
            checkButton.backgroundColor = UIColor(resource: .black30)
            checkButton.addSubview(checkIcon)
            
            NSLayoutConstraint.activate([
                checkIcon.centerXAnchor.constraint(equalTo: checkButton.centerXAnchor),
                checkIcon.centerYAnchor.constraint(equalTo: checkButton.centerYAnchor),
                checkIcon.widthAnchor.constraint(equalTo: checkButton.widthAnchor, multiplier: 0.8)
            ])
        } else {
            checkIcon.removeFromSuperview()
            checkButton.backgroundColor = UIColor(resource: .white60)
        }
        
        wasChecked.toggle()
    }
    
    func loadData() {
        titleLabel.text = task.name
    }
    
    func setupTapGesture() {
        let cardTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCard))
                self.addGestureRecognizer(cardTapGesture)
                self.isUserInteractionEnabled = true
    }
    
    @objc func didTapCheckButton() {
        reloadButton()
    }
    
    @objc private func didTapCard() {
        cardTapAction?()
    }
}


#Preview {
    let task = MockTask(
        name: "Administer medications",
        note: "Check medication log for proper dosage and timing.",
        reminder: true,
        time: Calendar.current.date(from: DateComponents(hour: 7, minute: 30))!,
        daysOfTheWeek: [.friday, .sunday],
        startDate: Calendar.current.date(from: DateComponents(year: 2025, month: 10, day: 10))!,
        endDate: Calendar.current.date(from: DateComponents(year: 2025, month: 12, day: 31))!
    )
    TaskCard(task: task)
}
