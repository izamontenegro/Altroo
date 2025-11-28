//
//  SymptomDetailViewController.swift
//  Altroo
//
//  Created by Raissa Parente on 13/10/25.
//

import UIKit

class SymptomDetailViewController: UIViewController {
    var symptom: Symptom
    var onEditTapped: ((Symptom) -> Void)?
    
    let vStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = Layout.mediumSpacing
        
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
        
        let name = InfoRowView(title: "name".localized, info: symptom.name ?? "name".localized)
        let time = InfoRowView(title: String(localized: "time"), info: DateFormatterHelper.hourFormatter(date: symptom.date ?? .now))
        let notes = InfoRowView(title: "Notes", info: symptom.symptomDescription ?? "observation".localized)
        
        vStack.addArrangedSubview(name)
        vStack.addArrangedSubview(time)
        vStack.addArrangedSubview(notes)
        
        view.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Layout.mediumSpacing),
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.mediumSpacing),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.mediumSpacing),
        ])
    }
    
    private func configureNavBar() {
        navigationItem.title = "Intercorrência"
        
        let closeButton = UIBarButtonItem(title: "close".localized, style: .done, target: self, action: #selector(closeTapped))
        closeButton.tintColor = .blue10
        navigationItem.leftBarButtonItem = closeButton
        
        let editButton = UIBarButtonItem(title: "edit".localized, style: .plain, target: self, action: #selector(editTapped))
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
        onEditTapped?(symptom)
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
