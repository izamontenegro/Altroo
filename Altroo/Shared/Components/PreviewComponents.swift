//
//  PreviewComponents.swift
//  Altroo
//
//  Created by Raissa Parente on 06/10/25.
//

import UIKit
import SwiftUI

class ComponentPreviewViewController: UIViewController {

    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 20
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Visualizar Componentes"
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.textAlignment = .center
        return label
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        previewComponents()
    }


    private func setupView() {
        view.backgroundColor = .systemBackground

        view.addSubview(titleLabel)
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }


    private func previewComponents() {
        // TEXTFIELD
        let textField = StandardTextfield(
            width: 250,
            height: 45,
            title: StandardLabel(labelText: "Nome",
                                 labelFont: .sfPro,
                                 labelType: .title3,
                                 labelColor: UIColor(resource: .black10),
                                 labelWeight: .medium
                                ),
            placeholder: "Maria Clara"
        )
//        textField.placeholder = "Digite algo..."
//        textField.borderStyle = .roundedRect

        // SEGMENTEDCONTROL
        let segmentedControl = StandardSegmentedControl(items: ["Opção 1", "Opção 2", "Opção 3"])
        segmentedControl.selectedSegmentIndex = 0

        // TOGGLE
        let toggleSwitch = StandardToggle()

        // BUTTONS
        //original button
        let button = PrimaryStyleButton(title: "1 Copo (250ml)")
        
        //are all descendants of PrimaryStyleButton()
        let button2 = StandardConfirmationButton(title: "Continuar")
        let button3 = WideRectangleButton(title: "O dia todo")
        let button4 = PopupMenuButton(title: "Selecione")
        let button5 = ArrowWideRectangleButton(title: "Meu perfil")

        let button6 = PlusButton()

        
        //CAPSULES
        //these are views, not buttons
        //to make a capsule button add it as the button's view
//        let capsule1 = CapsuleWithCircleView(iconName: "pencil", text: "Editar Seções", mainColor: UIColor(resource: .teal80), accentColor: UIColor(resource: .teal20))
        let capsule2 = CapsuleIconView(iconName: "drop.fill", text: "250ml")
        
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(segmentedControl)
        stackView.addArrangedSubview(toggleSwitch)
        stackView.addArrangedSubview(button)
        stackView.addArrangedSubview(button2)
        stackView.addArrangedSubview(button3)
        stackView.addArrangedSubview(button4)
        stackView.addArrangedSubview(button5)
        stackView.addArrangedSubview(button6)
//        stackView.addArrangedSubview(capsule1)
        stackView.addArrangedSubview(capsule2)
    }
}

#if DEBUG
struct ComponentPreviewViewController_Preview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ComponentPreviewViewController {
        return ComponentPreviewViewController()
    }

    func updateUIViewController(_ uiViewController: ComponentPreviewViewController, context: Context) {
        // Não é necessário fazer nada aqui para este caso
    }
}

#Preview {
    ComponentPreviewViewController_Preview()
}
#endif
