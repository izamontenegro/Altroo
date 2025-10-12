//
//  MedicalRecordViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 11/10/25.
//

import UIKit

final class MedicalRecordViewController: GradientNavBarViewController {
    
    private(set) var mockPerson: CareRecipient!

    // ADICIONAR BOTAO EXPORTAR
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }

    private func setupLayout() {
        view.backgroundColor = .pureWhite

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        let content = UIStackView()
        content.axis = .vertical
        content.spacing = 24
        content.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(content)

        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30),
            content.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            content.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            content.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -40),
            content.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        content.addArrangedSubview(makeHeaderSection())

        content.addArrangedSubview(makeCompletionAlertAndButton())

        content.addArrangedSubview(makeSection(title: "Dados Pessoais", content: """
        Nome: Karlisson Oliveira
        Nascimento: 28/02/1940 (85 anos)
        Peso: 84 Kg   Altura: 1,63 m
        Endereço: Rua Um, 1001 – Bairro ZeroLândia
        Contatos: Maria José  (85) 99898-0908
        """))

        // secoes
        
        content.addArrangedSubview(makeSection(title: "Problemas de Saúde", content: """
        Doenças: Insuficiência cardíaca, Hipertensão, Diabetes
        Cirurgias: Redução de Estômago – 12/06/2003
        Alergias: Pólen, Poeira (Rinite)
        Observação: Queda em 21/03/2021, fraturou o braço
        """))

        content.addArrangedSubview(makeSection(title: "Estado Físico", content: """
        Visão: Completa
        Audição: Comprometida
        Locomoção: Acamado sem movimentação
        Saúde Bucal: Uso de prótese dentária
        """))

        content.addArrangedSubview(makeSection(title: "Estado Mental", content: """
        Comportamento: Deprimido | Calmo
        Orientação: Desorientado em tempo e espaço
        Memória: Esquecimento frequente
        Cognição: Baixa capacidade
        """))

        content.addArrangedSubview(makeSection(title: "Cuidados Pessoais", content: """
        Banho: Ajuda parcial
        Higiene: Baixa dependência
        Excreção: Usa fralda
        Alimentação: Pastosa
        Equipamentos: Sonda, Bolsa de colostomia, Soro intravenoso
        """))
    }

    // MARK: - Header
    private func makeHeaderSection() -> UIView {
        let container = UIView()
        container.backgroundColor = .clear

        let title = StandardLabel(
            labelText: "Ficha Médica",
            labelFont: .sfPro,
            labelType: .title2,
            labelColor: .black10,
            labelWeight: .semibold
        )

        let subtitle = StandardLabel(
            labelText: "Reúna as informações de saúde do assistido em um só lugar, de forma simples e acessível.",
            labelFont: .sfPro,
            labelType: .body,
            labelColor: .black30,
            labelWeight: .regular
        )
        subtitle.numberOfLines = 0
        
        let track = UIView()
        track.translatesAutoresizingMaskIntoConstraints = false
        track.backgroundColor = .blue80
        track.layer.cornerRadius = 8

        let fill = UIView()
        fill.translatesAutoresizingMaskIntoConstraints = false
        fill.layer.cornerRadius = 8
        fill.clipsToBounds = true
        track.addSubview(fill)

        let percent = StandardLabel(
            labelText: "80%",
            labelFont: .sfPro,
            labelType: .callOut,
            labelColor: .blue20,
            labelWeight: .medium
        )

        let progressRow = UIStackView(arrangedSubviews: [track, percent])
        progressRow.axis = .horizontal
        progressRow.alignment = .center
        progressRow.spacing = 10

//        let date = StandardLabel(
//            labelText: "Atualizada em: 28/10/2025",
//            labelFont: .sfPro,
//            labelType: .footnote,
//            labelColor: .gray,
//            labelWeight: .regular
//        )

        let stack = UIStackView(arrangedSubviews: [title, subtitle, progressRow])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(stack)
        
        
        NSLayoutConstraint.activate([
            track.heightAnchor.constraint(equalToConstant: 15),
            track.widthAnchor.constraint(greaterThanOrEqualToConstant: 110),
            fill.leadingAnchor.constraint(equalTo: track.leadingAnchor),
            fill.centerYAnchor.constraint(equalTo: track.centerYAnchor),
            fill.heightAnchor.constraint(equalTo: track.heightAnchor),
            
            // TODO: CHANGE HERE WHEN HAVE THE PROPER FUNCTION
            fill.widthAnchor.constraint(equalTo: track.widthAnchor, multiplier: 0.70),

        ])
        
        DispatchQueue.main.async {
            let gradient = CAGradientLayer()
            gradient.colors = [
                UIColor.blue10.cgColor,
                UIColor.blue50.cgColor
            ]
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
            gradient.frame = fill.bounds
            gradient.cornerRadius = 5
            fill.layer.insertSublayer(gradient, at: 0)
        }

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: container.topAnchor),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])

        return container
    }

    // MARK: - Edit medical record
    private func makeCompletionAlertAndButton() -> UIView {
        let wrapper = UIStackView()
        wrapper.axis = .vertical
        wrapper.spacing = -15
        wrapper.translatesAutoresizingMaskIntoConstraints = false

        let alertBox = UIView()
        alertBox.backgroundColor = UIColor.teal80
        alertBox.layer.cornerRadius = 5

        let icon = UIImageView(image: UIImage(systemName: "exclamationmark.triangle.fill"))
        icon.tintColor = .teal10
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.widthAnchor.constraint(equalToConstant: 36).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 36).isActive = true

        let label = StandardLabel(
            labelText: "Finalize o preenchimento para ter os dados de saúde do paciente à mão quando precisar.",
            labelFont: .sfPro,
            labelType: .subHeadline,
            labelColor: .teal10,
            labelWeight: .regular
        )
        label.numberOfLines = 0

        let alertStack = UIStackView(arrangedSubviews: [icon, label])
        alertStack.axis = .horizontal
        alertStack.alignment = .center
        alertStack.spacing = 10
        alertStack.translatesAutoresizingMaskIntoConstraints = false

        alertBox.addSubview(alertStack)
        NSLayoutConstraint.activate([
            alertStack.topAnchor.constraint(equalTo: alertBox.topAnchor, constant: 8),
            alertStack.bottomAnchor.constraint(equalTo: alertBox.bottomAnchor, constant: -23),
            alertStack.leadingAnchor.constraint(equalTo: alertBox.leadingAnchor, constant: 8),
            alertStack.trailingAnchor.constraint(equalTo: alertBox.trailingAnchor, constant: -8)
        ])

        let editButton = makeFilledButton(icon: UIImage(systemName: "square.and.pencil"), title: "Editar Ficha Médica")
        wrapper.addArrangedSubview(alertBox)
        wrapper.addArrangedSubview(editButton)
        
//        wrapper.backgroundColor = UIColor.teal80
//        wrapper.layer.cornerRadius = 8


        return wrapper
    }

    // MARK: - Cards / Seções
    private func makeSection(title: String, content: String) -> UIView {
        let container = UIView()
        container.backgroundColor = .clear

        let header = UIView()
        header.backgroundColor = UIColor.blue30
        header.layer.cornerRadius = 4
        header.translatesAutoresizingMaskIntoConstraints = false

        let icon = UIImageView(image: UIImage(systemName: "person.fill"))
        icon.tintColor = .pureWhite
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.widthAnchor.constraint(equalToConstant: 18).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 19).isActive = true
        
        let titleLabel = StandardLabel(
            labelText: title,
            labelFont: .sfPro,
            labelType: .body,
            labelColor: .pureWhite,
            labelWeight: .semibold
        )
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let titleStack = UIStackView()
        titleStack.axis = .horizontal
        titleStack.spacing = 8
        titleStack.translatesAutoresizingMaskIntoConstraints = false

        titleStack.addArrangedSubview(icon)
        titleStack.addArrangedSubview(titleLabel)

        header.addSubview(titleStack)
        NSLayoutConstraint.activate([
            titleStack.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 12),
            titleStack.centerYAnchor.constraint(equalTo: header.centerYAnchor)
        ])

        let body = StandardLabel(
            labelText: content,
            labelFont: .sfPro,
            labelType: .footnote,
            labelColor: .black10,
            labelWeight: .regular
        )
        body.numberOfLines = 0
        body.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(header)
        container.addSubview(body)

        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: container.topAnchor),
            header.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 36),

            body.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 8),
            body.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            body.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            body.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12)
        ])

        return container
    }

    // MARK: - Botão teal
    private func makeFilledButton(icon: UIImage?, title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = .teal20
        button.layer.cornerRadius = 23
        button.heightAnchor.constraint(equalToConstant: 46).isActive = true

        let iconView = UIImageView(image: icon)
        iconView.tintColor = .white
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.widthAnchor.constraint(equalToConstant: 20).isActive = true

        let label = StandardLabel(
            labelText: title,
            labelFont: .sfPro,
            labelType: .callOut,
            labelColor: .pureWhite,
            labelWeight: .medium
        )

        let stack = UIStackView(arrangedSubviews: [iconView, label])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false

        button.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])

        return button
    }
    
    private func createMockPerson() {
        let stack = CoreDataStack.shared
        let service = CoreDataService(stack: stack)

        // MARK: - Personal Data
        let personalData = PersonalData(context: stack.context)
        personalData.name = "Raissa Parente"
        personalData.address = "Rua das Acácias, 123 - Fortaleza, CE"
        personalData.gender = "Feminino"
        personalData.dateOfBirth = Calendar.current.date(from: DateComponents(year: 1957, month: 8, day: 15))
        personalData.height = 1.62
        personalData.weight = 64.5

        // MARK: - Health Problems
        let health = HealthProblems(context: stack.context)
        health.allergies = ["Lactose", "Poeira"]
        health.surgery = ["Cirurgia de catarata (2018)"]
        health.observation = "Pressão arterial controlada com medicação."

        // MARK: - Mental State
        let mental = MentalState(context: stack.context)
        mental.cognitionState = "Ligeira confusão ocasional, especialmente à noite"
        mental.memoryState = "Memória de longo prazo preservada, curto prazo comprometida"
        mental.emotionalState = "Tranquila, mas com episódios de ansiedade"
        mental.orientationState = "Orientada no tempo e espaço na maior parte do dia"

        // MARK: - Physical State
        let physical = PhysicalState(context: stack.context)
        physical.mobilityState = "Anda com auxílio de bengala"
        physical.hearingState = "Usa aparelho auditivo no ouvido direito"
        physical.visionState = "Visão reduzida (usa óculos)"
        physical.oralHealthState = "Dentição parcial, boa higiene"

        // MARK: - Personal Care
        let care = PersonalCare(context: stack.context)
        care.bathState = "Necessita de supervisão"
        care.hygieneState = "Autônoma"
        care.excretionState = "Utiliza fralda noturna"
        care.feedingState = "Alimenta-se sozinha, dieta branda"
        care.equipmentState = "Bengala, aparelho auditivo e óculos"

        // MARK: - Care Recipient
        let recipient = CareRecipient(context: stack.context)
        recipient.personalData = personalData
        recipient.healthProblems = health
        recipient.mentalState = mental
        recipient.physicalState = physical
        recipient.personalCare = care

        health.careRecipient = recipient
        mental.careRecipient = recipient
        physical.careRecipient = recipient
        care.careRecipient = recipient
        personalData.careRecipient = recipient

        
        mockPerson = recipient
        service.save()
    }
}

#Preview {
    UINavigationController(rootViewController: MedicalRecordViewController())
}
