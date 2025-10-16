//
//  TaskCard.swift
//  Altroo
//
//  Created by Raissa Parente on 07/10/25.
//

import UIKit

protocol TaskCardDelegate: AnyObject {
    func taskCardDidSelect(_ task: TaskInstance)
    func taskCardDidMarkAsDone(_ task: TaskInstance)
}

class TaskCard: InnerShadowView {
    let task: TaskInstance
    weak var delegate: TaskCardDelegate?
    
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
    
    init(task: TaskInstance) {
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
        
        timeTag = TagView(text: "\(task.time!.formatted(date: .omitted, time: .shortened))", iconName: "alarm.fill")
        guard let timeTag else { return }
        
        addSubview(titleLabel)
        addSubview(checkButton)
        addSubview(timeTag)
        
        checkButton.addTarget(self, action: #selector(didTapCheckButton), for: .touchUpInside)
        setupTapGesture()
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            
            timeTag.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            timeTag.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            timeTag.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            
            checkButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            checkButton.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            checkButton.heightAnchor.constraint(equalToConstant: 18),
            checkButton.widthAnchor.constraint(equalTo: checkButton.heightAnchor),
        ])
        
        loadAppearance()
    }
        
    func setDoneAppearance () {
        checkButton.backgroundColor = .black30
        checkButton.addSubview(checkIcon)
        
        NSLayoutConstraint.activate([
            checkIcon.centerXAnchor.constraint(equalTo: checkButton.centerXAnchor),
            checkIcon.centerYAnchor.constraint(equalTo: checkButton.centerYAnchor),
            checkIcon.widthAnchor.constraint(equalTo: checkButton.widthAnchor, multiplier: 0.8)
        ])
        
        backgroundColor = .white50

        timeTag?.setSelectedAppearance(true)
    }
    
    func setUndoneAppearance() {
        checkIcon.removeFromSuperview()
        checkButton.backgroundColor = .white60
        
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
        delegate?.taskCardDidSelect(task)
    }
}
