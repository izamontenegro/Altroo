//
//  SymptomDetailViewController.swift
//  Altroo
//
//  Created by Raissa Parente on 13/10/25.
//

import UIKit

class SymptomDetailViewController: UIViewController {
    var symptom: Symptom
    
    let vStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 16
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    init(symptom: Symptom) {
        self.symptom = symptom
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        let name = InfoRowView(title: "Nome", info: symptom.name ?? "Nome")
        let time = InfoRowView(title: "Horário", info: DateFormatterHelper.hourFormatter(date: symptom.date ?? .now))
        let notes = InfoRowView(title: "Notes", info: symptom.symptomDescription ?? "Observação")
        
        vStack.addArrangedSubview(name)
        vStack.addArrangedSubview(time)
        vStack.addArrangedSubview(notes)
        
        view.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
        ])
    }
    
    private func configureNavBar() {
        navigationItem.title = "Intercorrência"
        
        let closeButton = UIBarButtonItem(title: "Fechar", style: .done, target: self, action: #selector(closeTapped))
        closeButton.tintColor = .blue10
        navigationItem.leftBarButtonItem = closeButton
        
        let editButton = UIBarButtonItem(title: "Editar", style: .plain, target: self, action: #selector(closeTapped))
        editButton.tintColor = .blue10
        navigationItem.rightBarButtonItem = editButton
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        navigationItem.scrollEdgeAppearance = appearance
    }

    
    @objc func closeTapped() {
        dismiss(animated: true)
    }
    
    @objc func editTapped() {
        dismiss(animated: true)
    }
}

//#Preview {
//    SymptomDetailViewController(task: MockTask(
//        name: "Administer medications",
//        note: "Check medication log for proper dosage and timing.",
//        reminder: true,
//        time: Calendar.current.date(from: DateComponents(hour: 7, minute: 30))!,
//        daysOfTheWeek: [.friday, .sunday],
//        startDate: Calendar.current.date(from: DateComponents(year: 2025, month: 10, day: 10))!,
//        endDate: nil
//    )
//    )
//}
