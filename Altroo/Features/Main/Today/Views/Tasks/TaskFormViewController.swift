//
//  TaskFormViewController.swift
//  Altroo
//
//  Created by Raissa Parente on 16/10/25.
//

import UIKit
import Combine

class TaskFormViewController: GradientNavBarViewController {

    let titleLabel = StandardLabel(labelText: "", labelFont: .sfPro, labelType: .title2, labelColor: UIColor(resource: .black10), labelWeight: .semibold)
    
    let confirmButton = StandardConfirmationButton(title: "")
    let deleteButton = OutlineButton(title: "Deletar", color: .red20)
    private var confirmBottomConstraint: NSLayoutConstraint?

    let nameTexfield = StandardTextfield(placeholder: "Nome")
    let noteTexfield = StandardTextfield(placeholder: "Observação")

    var hourPickers: [UIDatePicker] = []
    let addTimeButton = PrimaryStyleButton(title: "Novo Horário")
    let startDatePicker: UIDatePicker = UIDatePicker.make(mode: .date)
    let endDatePicker: UIDatePicker = UIDatePicker.make(mode: .date)
    
    let hourStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    let dateStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    let contentStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    var endDateSection: UIView!
    var continuousButton: PopupMenuButton!
    var weekdayRow: RepeatDaysRow!
    
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .pureWhite
        view.addSubview(titleLabel)
        view.addSubview(confirmButton)
        view.addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            contentStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    func configure(title: String, confirmButtonText: String, showDelete: Bool = false) {
        titleLabel.text = title
        confirmButton.updateTitle(confirmButtonText)
        
        if showDelete {
//            deleteButton.updateColor(.red10)
            view.addSubview(deleteButton)
            NSLayoutConstraint.activate([
                deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Layout.mediumSpacing)
            ])
            confirmBottomConstraint = confirmButton.bottomAnchor.constraint(equalTo: deleteButton.topAnchor, constant: -Layout.mediumSpacing)
            confirmBottomConstraint?.isActive = true
        } else {
            deleteButton.removeFromSuperview()
            confirmBottomConstraint = confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Layout.bigButtonBottomPadding)
            confirmBottomConstraint?.isActive = true
        }
    }

    func setupContent() {
            //name
            let nameSection = FormSectionView(title: "Nome", content: nameTexfield)
            contentStack.addArrangedSubview(nameSection)

            //time
            let hourSection = FormSectionView(title: "Horário", content: hourStack)
            hourStack.addArrangedSubview(addTimeButton)
            contentStack.addArrangedSubview(hourSection)

            //repeat
            weekdayRow = RepeatDaysRow()
            let repeatSection = FormSectionView(title: "Repetir", content: weekdayRow)
            contentStack.addArrangedSubview(repeatSection)

            //duration
            startDatePicker.addTarget(self, action: #selector(startDateChanged(_:)), for: .valueChanged)
            let startSection = FormSectionView(title: "Início", content: startDatePicker)
            endDatePicker.addTarget(self, action: #selector(endDateChanged(_:)), for: .valueChanged)
            endDateSection = FormSectionView(title: "Término", content: endDatePicker)
            
            dateStack.addArrangedSubview(startSection)
            contentStack.addArrangedSubview(dateStack)

            //notes
            let noteSection = FormSectionView(title: "Observações", content: noteTexfield)
            contentStack.addArrangedSubview(noteSection)
        }
    
    private func updateEndDateVisibility(_ isContinuous: Bool) {
        if isContinuous {
            endDateSection.removeFromSuperview()
        } else {
            dateStack.insertArrangedSubview(endDateSection, at: 1)
        }
    }
    
    func insertContinuousPicker(_ button: PopupMenuButton, showEndDate: Bool) {
        continuousButton = button
         let durationSection = FormSectionView(title: "Duração", content: continuousButton)
         dateStack.addArrangedSubview(durationSection)
         if showEndDate {
             dateStack.insertArrangedSubview(endDateSection, at: 1)
         }
     }

    func addEndDate() {
        dateStack.insertArrangedSubview(endDateSection, at: 1)
    }
    
    func removeEndDate() {
        endDateSection.removeFromSuperview()
    }

    @objc func startDateChanged(_ picker: UIDatePicker) {}
    @objc func endDateChanged(_ picker: UIDatePicker) {}
}

