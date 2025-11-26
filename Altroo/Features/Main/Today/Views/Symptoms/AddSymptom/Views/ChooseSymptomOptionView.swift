//
//  ChooseSymptomOptionView.swift
//  Altroo
//
//  Created by Raissa Parente on 24/11/25.
//

import UIKit
import Combine

final class ChooseSymptomOptionView: UIView {
    
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: AddSymptomViewModel
    
    private var symptomButtons: [OutlineRectangleButton] = []
    private var textfield = StandardTextfield(placeholder: "Adicione o título da intercorrência")
    
    init(viewModel: AddSymptomViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        let optionsList = makeOptionList()
        addSubview(optionsList)
        optionsList.pinToEdges(of: self)
        
        bindViewModel()
        
        translatesAutoresizingMaskIntoConstraints = false
        
        textfield.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func bindViewModel() {
        viewModel.$selectedSymptom
            .sink { [weak self] selected in
                guard let self else { return }
                textfield.text = ""
                for button in symptomButtons {
                    let isSelected = button.associatedData as? SymptomExample == selected
                    button.isSelected = isSelected
                }

            }
            .store(in: &cancellables)
        
        //name textfield
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification,
                                             object: textfield)
        .compactMap { ($0.object as? UITextField)?.text }
        .sink { [weak self] newText in
            if self?.viewModel.selectedSymptom != nil {
                self?.viewModel.selectedSymptom = nil
            }
            self?.viewModel.name = newText
        }
        .store(in: &cancellables)
    }
    
    
    func makeOptionList() -> UIView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 16
        
        for category in SymptomCategory.allCases {
            stack.addArrangedSubview(makeSection(for: category))
        }
        
        stack.addArrangedSubview(makeTextfieldSection())
        
        return stack
    }
    
    func makeSection(for category: SymptomCategory) -> UIView {
        let title = StandardLabel(labelText: category.displayText,
                                  labelFont: .sfPro,
                                  labelType: .body,
                                  labelColor: .blue10,
                                  labelWeight: .semibold)
        let rect = UIView()
        rect.backgroundColor = .blue80
        rect.layer.cornerRadius = 4
        rect.addSubview(title)
        title.pinToEdges(of: rect, withConstant: 8)
        
        var buttons: [UIView] = category.symptoms.map { symptom in
            let btn = OutlineRectangleButton(title: symptom.displayText)
            btn.associatedData = symptom
            btn.addTarget(self, action: #selector(symptomTapped(_:)), for: .touchUpInside)
            symptomButtons.append(btn)
            return btn
        }
        
        let buttonsView = FlowLayoutView(views: buttons)
        
        let stack = UIStackView(arrangedSubviews: [rect, buttonsView])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 6
        
        return stack
    }
    
    func makeTextfieldSection() -> UIView {
        let title = StandardLabel(labelText: "Outro",
                                  labelFont: .sfPro,
                                  labelType: .body,
                                  labelColor: .blue10,
                                  labelWeight: .semibold)
        let rect = UIView()
        rect.backgroundColor = .blue80
        rect.layer.cornerRadius = 4
        rect.addSubview(title)
        title.pinToEdges(of: rect, withConstant: 8)
        
        let stack = UIStackView(arrangedSubviews: [rect, textfield])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 6
        
        return stack
    }
    
    @objc private func symptomTapped(_ sender: OutlineRectangleButton) {
        let symptom: SymptomExample = sender.associatedData as! SymptomExample
        
        if viewModel.selectedSymptom == symptom {
            viewModel.selectedSymptom = nil
        } else {
            viewModel.selectedSymptom = symptom
        }
    }
    
    @objc private func dismissKeyboard() {
        endEditing(true)
    }
    

}

extension ChooseSymptomOptionView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
