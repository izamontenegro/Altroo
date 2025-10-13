//
//  SymptomsCard.swift
//  Altroo
//
//  Created by Raissa Parente on 13/10/25.
//
import UIKit

struct MockSymptom {
    var name: String?
    var date: Date?
    var symptomDescription: String?
}

protocol SymptomsCardDelegate: AnyObject {
    func tappedSymptom(_ symptom: Symptom, on card: SymptomsCard)
}

class SymptomsCard: UIView {
    let symptoms: [Symptom]
    weak var delegate: SymptomsCardDelegate?
    
    let vStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 16
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    init(symptoms: [Symptom]) {
        self.symptoms = symptoms
        
        super.init(frame: .zero)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 100)
    }
    
    func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 12
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(vStack)

        if symptoms.isEmpty {
            makeEmptyState()
        } else {
            makeContent()
        }
        
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Layout.viewPadding),
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Layout.viewPadding),
            vStack.topAnchor.constraint(equalTo: topAnchor, constant: Layout.viewPadding),
            vStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Layout.viewPadding),
        ])
        
    }
    
    func makeContent() {
        for (index, symptom) in symptoms.enumerated() {
            let row = makeSymptomLine(for: symptom)
            row.tag = index
            row.addTarget(self, action: #selector(symptomTapped(_:)), for: .touchUpInside)
            vStack.addArrangedSubview(row)
            row.widthAnchor.constraint(equalTo: vStack.widthAnchor).isActive = true

            
            let divider = UIView()
            divider.backgroundColor = .white70
            divider.translatesAutoresizingMaskIntoConstraints = false
            divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
            vStack.addArrangedSubview(divider)
            vStack.setCustomSpacing(Layout.verySmallSpacing, after: row)
        }
    }
    
    func makeEmptyState() {
        let text = StandardLabel(labelText: "Nenhuma intercorrência reportada", labelFont: .sfPro, labelType: .callOut, labelColor: .black30)
        vStack.addArrangedSubview(text)
    }
    
    func makeSymptomLine(for symptom: Symptom) -> UIButton {
        let name = StandardLabel(labelText: symptom.name ?? "Intercorrência", labelFont: .sfPro, labelType: .callOut, labelColor: .black10)
        
        let icon = UIImageView(image: UIImage(systemName: "exclamationmark.triangle.fill"))
        icon.tintColor = .black10
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.setContentHuggingPriority(.required, for: .horizontal)
        icon.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        let time = StandardLabel(labelText: DateFormatterHelper.hourFormatter(date: symptom.date ?? .now), labelFont: .sfPro, labelType: .callOut, labelColor: .black30)
        time.setContentHuggingPriority(.required, for: .horizontal)
        
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        
        let hStack = UIStackView(arrangedSubviews: [icon, name, spacer, time])
        hStack.axis = .horizontal
        hStack.alignment = .fill
        hStack.distribution = .equalSpacing
        hStack.spacing = CGFloat(Layout.verySmallSpacing)
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.isUserInteractionEnabled = false
        
        let button = UIButton(type: .system)
        button.addSubview(hStack)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            hStack.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: button.trailingAnchor),
            hStack.topAnchor.constraint(equalTo: button.topAnchor),
            hStack.bottomAnchor.constraint(equalTo: button.bottomAnchor)
        ])

        return button
    }
    
    @objc private func symptomTapped(_ sender: UIButton) {
        let index = sender.tag
        let symptom = symptoms[index]
        delegate?.tappedSymptom(symptom, on: self)
    }
}

//#Preview {
//    let symptoms = [
//        Symptom(name: "Vômito", date: .now, symptomDescription: ""),
//        Symptom(name: "Queda", date: .now, symptomDescription: ""),
//    ]
//    SymptomsCard(symptoms: symptoms)
//}
