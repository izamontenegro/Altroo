//
//  EditPersonalDataViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 28/10/25.
//

import UIKit

final class EditPersonalDataView: UIView {
    let viewModel: EditMedicalRecordViewModel
    weak var delegate: EditMedicalRecordViewControllerDelegate?

    // Exemplo de campos (substitua/adapte pelos seus)
    private lazy var nameTextField = StandardTextfield(placeholder: "Nome do assistido")
    private lazy var addressTextField = StandardTextfield(placeholder: "Endereço do assistido")

    private let header: EditSectionHeaderView = {
        let header = EditSectionHeaderView(
            sectionTitle: "Dados Pessoais",
            sectionDescription: "Preencha os campos a seguir quanto aos dados básicos da pessoa cuidada.",
            sectionIcon: "person.fill"
        )
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()

    private lazy var formStack: UIStackView = {
        // Observação: substitua por seus FormSectionView e demais subviews reais.
        let nameSection = FormSectionView(title: "Nome", content: nameTextField, isObligatory: true)
        let addressSection = FormSectionView(title: "Endereço", content: addressTextField)

        let stack = UIStackView(arrangedSubviews: [nameSection, addressSection])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 22
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    init(viewModel: EditMedicalRecordViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupUI()
        fillInformations() // O que faz: já preenche os campos ao montar a view.
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupUI() {
        backgroundColor = .pureWhite

        addSubview(header)
        addSubview(formStack)

        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15),
            header.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            header.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            formStack.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 60),
            formStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            formStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            formStack.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -20)
        ])
    }

    // O que é: preenche os campos consultando o viewModel (mesma lógica que você já tem).
    // Como faz: busca o paciente, lê personalData e injeta nos textfields.
    // Por que faz: mantém a view autônoma para ser exibida em qualquer container.
    func fillInformations() {
        guard let patient = viewModel.userService.fetchCurrentPatient(),
              let personalData = patient.personalData else { return }

        nameTextField.text = personalData.name ?? ""
        addressTextField.text = personalData.address ?? ""
    }
}
