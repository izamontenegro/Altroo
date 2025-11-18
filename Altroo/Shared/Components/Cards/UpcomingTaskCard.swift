//
//  UpcomingTaskCard.swift
//  Altroo
//
//  Created by Raissa Parente on 18/11/25.
//

import UIKit

//protocol TaskCardDelegate: AnyObject {
//    func taskCardDidSelect(_ task: TaskInstance)
//    func taskCardDidMarkAsDone(_ task: TaskInstance)
//}

class UpcomingTaskCard: InnerShadowView {
    let task: RoutineTask
    weak var delegate: TaskCardDelegate?
    
    lazy var titleLabel = StandardLabel(labelText: task.name ?? "Tarefa",
                                   labelFont: .sfPro,
                                   labelType: .callOut,
                                   labelColor: UIColor(resource: .black10),
                                   labelWeight: .medium)
    
    var timeTag: TagView?
    
    let checkButton: UIButton = {
        let button = PaddedContentIgnoringButton()
        button.backgroundColor = UIColor(resource: .white60)
        button.layer.cornerRadius = 5
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let doneCheckButton: UIButton = {
        let button = PaddedContentIgnoringButton()
        button.backgroundColor = UIColor(resource: .blue30)
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let label = StandardLabel(
            labelText: "Feita",
            labelFont: .sfPro,
            labelType: .footnote,
            labelColor: .pureWhite,
            labelWeight: .medium
        )
        
        let icon = UIImageView(image: UIImage(systemName: "checkmark.square.fill"))
        icon.tintColor = .white
        icon.contentMode = .scaleAspectFit
        icon.setContentHuggingPriority(.required, for: .horizontal)
        
        let stack = UIStackView(arrangedSubviews: [label, icon])
        stack.axis = .horizontal
        stack.spacing = 6
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        button.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 4),
            stack.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -4),
            stack.topAnchor.constraint(equalTo: button.topAnchor, constant: 2),
            stack.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -2)
        ])

        return button
    }()
    
    init(task: RoutineTask) {
        self.task = task
        super.init(frame: .zero, color: .blue80)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = .pureWhite
        layer.cornerRadius = 10
        
        var end: String = ""
        let start: String = DateFormatterHelper.historyDateNumber(from: task.startDate!)
        if let endDate = task.endDate {
            end = "até \(DateFormatterHelper.historyDateNumber(from: endDate))"
        } else {
            end = "- Sem data final"
        }
        timeTag = TagView(text: "\(start) \(end)", iconName: "calendar")

        
        guard let timeTag else { return }
        
        addSubview(titleLabel)
        addSubview(timeTag)
        
//        setupTapGesture()
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            
            timeTag.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            timeTag.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            timeTag.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
        ])
        
    }
    
//    func setupTapGesture() {
////        let cardTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCard))
//        self.addGestureRecognizer(cardTapGesture)
//        self.isUserInteractionEnabled = true
//    }
    
    
//    @objc private func didTapCard() {
//        delegate?.taskCardDidSelect(task)
//    }
}
