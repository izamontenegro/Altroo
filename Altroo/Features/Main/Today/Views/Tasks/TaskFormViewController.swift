//
//  TaskFormViewController.swift
//  Altroo
//
//  Created by Raissa Parente on 16/10/25.
//

import UIKit
import Combine

class TaskFormViewController: GradientNavBarViewController {
    private var keyboardHandler: KeyboardHandler?

    let titleLabel = StandardHeaderView(title: "", subtitle: "")
    
    let confirmButton = StandardConfirmationButton(title: "")
    let deleteButton = OutlineButton(title: "Deletar", color: .red20)
    private var confirmBottomConstraint: NSLayoutConstraint?

    let nameTexfield = StandardTextfield(placeholder: "Nome")
    let noteTexfield = ObservationView()

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
    
    //sections
    private lazy var nameSection = FormSectionView(title: "Nome", content: nameTexfield)
    private lazy var hourSection = FormSectionView(title: "Horário", content: hourStack)
    private lazy var repeatSection = FormSectionView(title: "Repetir", content: weekdayRow)
    private lazy var startSection = FormSectionView(title: "Início", content: startDatePicker)
    private lazy var noteSection = FormSectionView(title: "Observações", content: noteTexfield)

    private lazy var contentStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            nameSection,
            hourSection,
            repeatSection,
            dateStack,
            noteSection,
            confirmButton,
            deleteButton
        ])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()

    var endDateSection: UIView!
    var continuousButton: PopupMenuButton!
    var weekdayRow: RepeatDaysRow = RepeatDaysRow()
    
    private let scrollView = UIScrollView.make(direction: .vertical)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        keyboardHandler = KeyboardHandler(viewController: self)
    }
    
    func setupUI() {
        view.backgroundColor = .pureWhite
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        
        nameTexfield.delegate = self
        noteTexfield.textView.delegate = self
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: Layout.smallSpacing),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: Layout.mediumSpacing),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -Layout.mediumSpacing),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -Layout.smallSpacing),
            contentStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -2 * Layout.mediumSpacing)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    func configure(title: String, subtitle: String, confirmButtonText: String, showDelete: Bool = false) {
        titleLabel.update(title: title, subtitle: subtitle)
        
        confirmButton.updateTitle(confirmButtonText)
        
        if showDelete {
            deleteButton.updateColor(.red10)
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
            hourStack.addArrangedSubview(addTimeButton)

            //duration
            startDatePicker.addTarget(self, action: #selector(startDateChanged(_:)), for: .valueChanged)
            endDatePicker.addTarget(self, action: #selector(endDateChanged(_:)), for: .valueChanged)
            endDateSection = FormSectionView(title: "Término", content: endDatePicker)
            
            dateStack.addArrangedSubview(startSection)
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
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension TaskFormViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension TaskFormViewController: UITextViewDelegate {
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
