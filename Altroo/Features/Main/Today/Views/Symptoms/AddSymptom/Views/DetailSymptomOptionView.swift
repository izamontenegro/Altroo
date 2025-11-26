//
//  DetailSymptomOptionView.swift
//  Altroo
//
//  Created by Raissa Parente on 24/11/25.
//

import UIKit
import Combine

final class DetailSymptomOptionView: UIView {
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: AddSymptomViewModel
        
    let noteTexfield = ObservationView(placeholder: "Detalhes opcionais")
    
    lazy var nameTag: OutlineRectangleButton = {
        let tag = OutlineRectangleButton(title: viewModel.name)
        tag.isSelected = true
        return tag
    }()
    lazy var nameRow = FlowLayoutView(views: [nameTag])

    let timePicker: UIDatePicker = UIDatePicker.make(mode: .time)
    let datePicker: UIDatePicker = UIDatePicker.make(mode: .date)
    
    lazy var nameSection = FormSectionView(title: "title".localized, content: nameRow)
    lazy var dateSection = FormSectionView(title: "date".localized, content: datePicker)

    let contentStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 16
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    init(viewModel: AddSymptomViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)

        bindViewModel()
        setupUI()
        setupActions()

        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) { fatalError() }
    
        func bindViewModel() {
            //note textfield
            NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: noteTexfield)
                .compactMap { ($0.object as? UITextField)?.text }
                .assign(to: \.note, on: viewModel)
                .store(in: &cancellables)
    
            //validation
            viewModel.$fieldErrors
                .receive(on: RunLoop.main)
                .sink { [weak self] errors in
                    self?.dateSection.setError(errors["date"])
                }
                .store(in: &cancellables)
    
        }

        private func setupActions() {
              datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
              timePicker.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
          }
    
    func setupUI() {
        backgroundColor = .white
                
        setupContent()
        
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
    }
    
    func setupContent() {
        addSubview(contentStack)
        
        //name
        contentStack.addArrangedSubview(nameSection)
        
        //notes
        let noteSection = FormSectionView(title: "observations".localized, content: noteTexfield)
        noteTexfield.delegate = self
        contentStack.addArrangedSubview(noteSection)
        
        //time
        let timeSection = FormSectionView(title: String(localized: "time"), content: timePicker)
                
        //date and time
        let dateTimeStack = UIStackView(arrangedSubviews: [dateSection, timeSection])
        dateTimeStack.axis = .horizontal
        dateTimeStack.distribution = .equalSpacing
        dateTimeStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.addArrangedSubview(dateTimeStack)
    }
    
    @objc
    private func dismissKeyboard() {
        endEditing(true)
    }

    
    @objc func dateChanged(_ picker: UIDatePicker) {
        viewModel.date = picker.date
    }
    
    @objc func timeChanged(_ picker: UIDatePicker) {
        viewModel.time = picker.date
    }
}

extension DetailSymptomOptionView: ObservationViewDelegate {
    func observationView(_ view: ObservationView, didChangeText text: String) {
        viewModel.note = text
    }
}
