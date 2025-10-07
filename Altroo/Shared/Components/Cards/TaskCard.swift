//
//  TaskCard.swift
//  Altroo
//
//  Created by Raissa Parente on 07/10/25.
//

import UIKit

class TaskCard: UIView {
    let task: MockTask
    
    var cardTapAction: (() -> Void)?
    let cardTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCard))

    let titleLabel = StandardLabel(labelText: "", labelFont: .sfPro, labelType: .h2, labelColor: .black, labelWeight: .medium)
    
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
    
    init(frame: CGRect = .zero, task: MockTask) {
        
        self.task = task
        
        super.init(frame: frame)
        
        setupUI()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = UIColor(resource: .white70)
        layer.cornerRadius = 10
        
        loadData()
        
        let timetag = makeTimeTag()
        timetag.translatesAutoresizingMaskIntoConstraints = false 
        addSubview(titleLabel)
        addSubview(checkButton)
        addSubview(timetag)
        
        checkButton.addTarget(self, action: #selector(didTapCheckButton), for: .touchUpInside)
        self.addGestureRecognizer(cardTapGesture)
                self.isUserInteractionEnabled = true
        
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
        let timeLabel = StandardLabel(labelText: "\(task.time.formatted(date: .omitted, time: .shortened))", labelFont: .sfPro, labelType: .h2, labelColor: .teal, labelWeight: .medium)
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
    
    @objc func didTapCheckButton() {
        reloadButton()
    }
    
    @objc private func didTapCard() {
        cardTapAction?()
    }
}


#Preview {
    let task = MockTask(name: "Banho", note: "", period: "Manha", frequency: "", reminder: false, time: .now, daysOfTheWeek: "")
    TaskCard(task: task)
}
