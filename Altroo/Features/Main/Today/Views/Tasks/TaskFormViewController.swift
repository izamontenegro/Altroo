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
    let deleteButton = OutlineButton(title: "delete".localized, color: .red20)
    private var confirmBottomConstraint: NSLayoutConstraint?

    let nameTexfield = StandardTextfield(placeholder: "Nome da tarefa")
    let noteTexfield = ObservationView()
    
    //TIME
    lazy var deleteTimeButton: MinusButton = {
        let btn = MinusButton()
        btn.widthAnchor.constraint(equalToConstant: 18).isActive = true
        btn.addTarget(self, action: #selector(didDeleteLastTime), for: .touchUpInside)
        return btn
    }()
    
    //"taskform_new_time".localized
    let addTimeButton = OutlineWithIconButton(title: "Adicionar Horário", iconName: "plus.circle.fill")
    var addTimeViews: [UIView] = []
    lazy var timePickersFlowView = FlowLayoutView(views: addTimeViews, maxWidth: view.bounds.width - 32)
    lazy var hourStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [timePickersFlowView])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //DATE
    
    //DATE
    let startDatePicker: UIDatePicker = UIDatePicker.make(mode: .date)
    let endDatePicker: UIDatePicker = UIDatePicker.make(mode: .date)
    private lazy var dateRow: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [startSection, endSection])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    let dateContent: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    lazy var nameSection = FormSectionView(title: "name".localized, content: nameTexfield)
    private lazy var hourSection = FormSectionView(title: String(localized: "time"), content: hourStack)
        
        //"taskform_repeat".localized
    private lazy var repeatSection = FormSectionView(title: "Essa tarefa irá se repetir?", content: weekdayRow)
    lazy var dateSection = FormSectionView(title: "Qual a duração desta tarefa?", content: dateContent)
        
    private lazy var noteSection = FormSectionView(title: "Observação", content: noteTexfield)
    lazy var startSection = FormSectionView(title: "Data Inicial", content: startDatePicker, isSubsection: true)
        //"taskform_end".localized
    lazy var endSection = FormSectionView(title: "Data Final", content: endDatePicker, isSubsection: true)
    lazy var dateSection = FormSectionView(title: "Qual a duração desta tarefa?", content: dateContent)
    lazy var startSection = FormSectionView(title: "Data Inicial", content: startDatePicker, isSubsection: true)
    lazy var endSection = FormSectionView(title: "Data Final", content: endDatePicker, isSubsection: true)
    var continuousButton: PopupMenuButton!
    private lazy var noteSection = FormSectionView(title: "observations".localized, content: noteTexfield)

    private lazy var contentStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            nameSection,
            hourSection,
            repeatSection,
            dateSection,
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

    var weekdayRow: RepeatDaysRow = RepeatDaysRow()
    
    let scrollView = UIScrollView.make(direction: .vertical)
        
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
        
        startDatePicker.addTarget(self, action: #selector(startDateChanged(_:)), for: .valueChanged)
        endDatePicker.addTarget(self, action: #selector(endDateChanged(_:)), for: .valueChanged)
    }

    func configure(title: String, subtitle: String, confirmButtonText: String, showDelete: Bool = false, continuousButtonTitle: String) {
        titleLabel.update(title: title, subtitle: subtitle)
        
        confirmButton.updateTitle(confirmButtonText)
        
        deleteButton.isHidden = !showDelete
        
        setupContinuousButton(with: continuousButtonTitle)
    }
    
    func setupContinuousButton(with title: String) {
        continuousButton = PopupMenuButton(title: title)
        continuousButton.showsMenuAsPrimaryAction = true
        continuousButton.changesSelectionAsPrimaryAction = true
    }
    
    func reloadDurationSection(startDate: Date?, endDate: Date?) {
        //reset everything
        dateContent.clearContent()
        
        startDatePicker.date = startDate ?? .now
        
            endSection.updateContent(continuousButton)
        if let endDate {
            endDatePicker.date = endDate
            endSection.updateContent(endDatePicker)

            dateContent.addArrangedSubview(dateRow)
            dateContent.addArrangedSubview(continuousButton)
        } else {
            endSection.updateContent(continuousButton)
            
            dateContent.addArrangedSubview(dateRow)
        }
    }
    
    func insertContinuousPicker(_ button: PopupMenuButton, showEndDate: Bool) {
        continuousButton = button
        let durationSection = FormSectionView(title: "taskform_duration".localized, content: continuousButton)
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
   
    @objc func didDeleteLastTime() {}

    
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
