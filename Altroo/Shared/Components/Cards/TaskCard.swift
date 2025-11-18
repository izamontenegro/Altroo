//
//  TaskCard.swift
//  Altroo
//
//  Created by Raissa Parente on 07/10/25.
//

import UIKit

protocol TaskCardDelegate: AnyObject {
    func taskCardDidMarkAsDone(_ task: TaskInstance)
}

protocol TaskCardNavigationDelegate: AnyObject {
    func taskCardDidSelect(_ task: TaskInstance)
}

class TaskCard: InnerShadowView {
    let task: TaskInstance
    weak var delegate: TaskCardDelegate?
    weak var navigationDelegate: TaskCardNavigationDelegate?
    
    let titleLabel = StandardLabel(labelText: "",
                                   labelFont: .sfPro,
                                   labelType: .callOut,
                                   labelColor: UIColor(resource: .black10),
                                   labelWeight: .medium)
    
    var timeTag: TagView?
    
    var isTaskDone: Bool {
        return task.isDone
    }
    
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
    
    init(task: TaskInstance) {
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
        
        loadData()
        
        
        timeTag = TagView(text: "\(task.time!.formatted(date: .omitted, time: .shortened))", iconName: "alarm.fill")
        if task.isLateDay || task.isLatePeriod {
            timeTag?.defaultBackgroundColor = .red80
            timeTag?.defaultLabelColor = .red20
            timeTag?.defaultIconTintColor = .red20
        }
        guard let timeTag else { return }
        
        addSubview(titleLabel)
        addSubview(timeTag)
        
        setupTapGesture()

        
        //check button
        addSubview(checkButton)
        addSubview(doneCheckButton)
        checkButton.addTarget(self, action: #selector(didTapCheckButton), for: .touchUpInside)
        doneCheckButton.addTarget(self, action: #selector(didTapCheckButton), for: .touchUpInside)
        checkButton.isHidden = task.isDone
        doneCheckButton.isHidden = !task.isDone
        
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            
            timeTag.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            timeTag.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            timeTag.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            
            checkButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            checkButton.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            checkButton.heightAnchor.constraint(equalToConstant: 20),
            checkButton.widthAnchor.constraint(equalToConstant: 20),
            
            doneCheckButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            doneCheckButton.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            doneCheckButton.heightAnchor.constraint(equalToConstant: 24),
        ])
        
        loadAppearance()
    }
    
    func setDoneAppearance () {
        checkButton.isHidden = true
        doneCheckButton.isHidden = false
        backgroundColor = .white50
        timeTag?.setSelectedAppearance(true)
    }
    
    func setUndoneAppearance() {
        checkButton.isHidden = false
        doneCheckButton.isHidden = true
        backgroundColor = .white
        timeTag?.setSelectedAppearance(false)
    }
    
    func loadAppearance() {
        if isTaskDone {
            setDoneAppearance()
        } else {
            setUndoneAppearance()
        }
    }
    
    func reloadButton() {
        if !isTaskDone {
            setDoneAppearance()
        } else {
            setUndoneAppearance()
        }
    }
    
    func loadData() {
        titleLabel.text = task.template?.name
    }
    
    func setupTapGesture() {
        let cardTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCard))
        self.addGestureRecognizer(cardTapGesture)
        self.isUserInteractionEnabled = true
    }
    
    @objc func didTapCheckButton() {
        reloadButton()
        delegate?.taskCardDidMarkAsDone(task)
    }
    
    @objc private func didTapCard() {
        navigationDelegate?.taskCardDidSelect(task)
    }
}

class PaddedContentIgnoringButton: UIButton {
    var hitPadding = UIEdgeInsets(top: -8, left: -8, bottom: -8, right: -8)

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.inset(by: hitPadding).contains(point)
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let inside = self.point(inside: point, with: event)
        return inside ? self : nil
    }
}
