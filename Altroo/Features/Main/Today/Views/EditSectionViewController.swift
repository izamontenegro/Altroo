//
//  EditSectionViewController.swift
//  Altroo
//
//  Created by Raissa Parente on 02/10/25.
//

import UIKit

class EditSectionViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .pureWhite
        
        setupLayout()
        setupItems()
    }

    // MARK: - Subviews
    private let titleLabel: StandardLabel = {
        let label = StandardLabel(
            labelText: "Editar Seção",
            labelFont: .sfPro,
            labelType: .title2,
            labelColor: .black10,
            labelWeight: .semibold
        )
        return label
    }()
    
    private let subtitleLabel: StandardLabel = {
        let label = StandardLabel(
            labelText: "Reordene ou oculte seção para personalizar a visualização.",
            labelFont: .sfPro,
            labelType: .subHeadline,
            labelColor: .black10.withAlphaComponent(0.6),
            labelWeight: .regular
        )
        label.numberOfLines = 0
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Layout
    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(stackView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Items
    private func setupItems() {
        let sections: [(title: String, checked: Bool, items: [String]?)] = [
            ("Necessidades Básicas", true, ["Alimentação", "Hidratação", "Fezes", "Urina"]),
            ("Tarefas", true, nil),
            ("Intercorrências", false, nil)
        ]
        
        for section in sections {
            let sectionView = makeSection(title: section.title, checked: section.checked, items: section.items)
            stackView.addArrangedSubview(sectionView)
        }
    }
    
    private func makeSection(title: String, checked: Bool, items: [String]?) -> UIStackView {
        // Section header
        let headerStack = UIStackView()
        headerStack.axis = .horizontal
        headerStack.alignment = .center
        headerStack.spacing = 8
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        
        let checkmark = UIImageView(image: UIImage(systemName: checked ? "checkmark.circle.fill" : "circle"))
        checkmark.tintColor = UIColor(resource: .teal20)
        checkmark.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkmark.widthAnchor.constraint(equalToConstant: 20),
            checkmark.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        let label = StandardLabel(labelText: title, labelFont: .sfPro, labelType: .title3, labelColor: .black10, labelWeight: .semibold)
        
        let dragIcon = UIImageView(image: UIImage(systemName: "line.horizontal.3"))
        dragIcon.tintColor = .black.withAlphaComponent(0.3)
        dragIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dragIcon.widthAnchor.constraint(equalToConstant: 20),
            dragIcon.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        headerStack.addArrangedSubview(checkmark)
        headerStack.addArrangedSubview(label)
        headerStack.addArrangedSubview(UIView()) // spacer
        headerStack.addArrangedSubview(dragIcon)
        
        let sectionStack = UIStackView()
        sectionStack.axis = .vertical
        sectionStack.spacing = 4
        sectionStack.addArrangedSubview(headerStack)
        
        // Items (subtasks)
        if let items = items {
            for item in items {
                let itemStack = UIStackView()
                itemStack.axis = .horizontal
                itemStack.alignment = .center
                itemStack.spacing = 8
                
                let itemCheck = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
                itemCheck.tintColor = UIColor(resource: .teal20)
                itemCheck.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    itemCheck.widthAnchor.constraint(equalToConstant: 16),
                    itemCheck.heightAnchor.constraint(equalToConstant: 16)
                ])
                
                let itemLabel = StandardLabel(labelText: item, labelFont: .sfPro, labelType: .subHeadline, labelColor: .black10, labelWeight: .regular)
                
                itemStack.addArrangedSubview(itemCheck)
                itemStack.addArrangedSubview(itemLabel)
                
                sectionStack.addArrangedSubview(itemStack)
            }
        }
        
        return sectionStack
    }
}

#Preview {
    EditSectionViewController()
}
