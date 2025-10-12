//
//  MedicalRecordViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 11/10/25.
//
import UIKit

final class MedicalRecordViewController: GradientNavBarViewController {

    private(set) var mockPerson: CareRecipient!
    private typealias InfoRow = (title: String, value: String)

    override func viewDidLoad() {
        super.viewDidLoad()
        createMockPerson()
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

        content.addArrangedSubview(makeSection(
            title: "Dados Pessoais",
            rows: buildPersonalDataRows(from: mockPerson), icon: "person.fill"
        ))

        content.addArrangedSubview(makeSection(
            title: "Problemas de Saúde",
            rows: buildHealthProblemsRows(from: mockPerson), icon: "heart.fill"
        ))

        content.addArrangedSubview(makeSection(
            title: "Estado físico",
            rows: buildPhysicalStateRows(from: mockPerson), icon: "figure"
        ))

        content.addArrangedSubview(makeSection(
            title: "Estado Mental",
            rows: buildMentalStateRows(from: mockPerson), icon: "brain.head.profile.fill"
        ))

        content.addArrangedSubview(makeSection(
            title: "Cuidados Pessoais",
            rows: buildPersonalCareRows(from: mockPerson), icon: "hand.raised.fill"
        ))
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

        let percentValue = completionPercent(for: mockPerson)
        let percent = StandardLabel(
            labelText: "\(Int(round(percentValue * 100)))%",
            labelFont: .sfPro,
            labelType: .callOut,
            labelColor: .blue20,
            labelWeight: .medium
        )

        let progressRow = UIStackView(arrangedSubviews: [track, percent])
        progressRow.axis = .horizontal
        progressRow.alignment = .center
        progressRow.spacing = 10

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
            fill.widthAnchor.constraint(equalTo: track.widthAnchor, multiplier: percentValue),

            stack.topAnchor.constraint(equalTo: container.topAnchor),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])

        DispatchQueue.main.async {
            let gradient = CAGradientLayer()
            gradient.colors = [UIColor.blue10.cgColor, UIColor.blue50.cgColor]
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
            gradient.frame = fill.bounds
            gradient.cornerRadius = 5
            fill.layer.insertSublayer(gradient, at: 0)
        }

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
        return wrapper
    }
    
    private func makeSectionHeader(title: String, icon: String) -> UIView {
        let header = UIView()
        header.backgroundColor = UIColor.blue30
        header.layer.cornerRadius = 4
        header.translatesAutoresizingMaskIntoConstraints = false

        let icon = UIImageView(image: UIImage(systemName: icon))
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

        let titleStack = UIStackView(arrangedSubviews: [icon, titleLabel])
        titleStack.axis = .horizontal
        titleStack.spacing = 8
        titleStack.translatesAutoresizingMaskIntoConstraints = false

        header.addSubview(titleStack)
        NSLayoutConstraint.activate([
            titleStack.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 12),
            titleStack.centerYAnchor.constraint(equalTo: header.centerYAnchor)
        ])
        
        return header
    }

    // MARK: - Data section
    private func makeSection(title: String, rows: [InfoRow], icon: String) -> UIView {
        let container = UIView()
        container.backgroundColor = .clear

        let header = makeSectionHeader(title: title, icon: icon)

        let itemsStack = UIStackView()
        itemsStack.axis = .vertical
        itemsStack.spacing = 10
        itemsStack.translatesAutoresizingMaskIntoConstraints = false

        for row in rows {
            let item = MedicalRecordInfoItemView(infotitle: row.title, infoDescription: row.value)
            item.translatesAutoresizingMaskIntoConstraints = false
            itemsStack.addArrangedSubview(item)
        }

        container.addSubview(header)
        container.addSubview(itemsStack)

        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: container.topAnchor),
            header.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 36),

            itemsStack.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 8),
            itemsStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            itemsStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            itemsStack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12)
        ])

        return container
    }

    private func buildPersonalDataRows(from r: CareRecipient) -> [InfoRow] {
        let p = r.personalData
        let name = p?.name ?? "—"
        let address = p?.address ?? "—"
        let dob = p?.dateOfBirth
        let age = dob.map { " (\(Date().yearsSince($0)) anos)" } ?? ""
        let dobStr = dob?.formattedBR() ?? "—"
        let weight: String
                if let w = r.personalData?.weight { weight = "\(w.clean) Kg" } else { weight = "—" }

                let height: String
                if let h = r.personalData?.height { height = "\(h.clean) m" } else { height = "—" }

        let contacts: String = {
            guard let set = r.personalData?.contacts as? Set<Contact>, !set.isEmpty else { return "—" }
            let mapped = set
                .sorted { ($0.name ?? "") < ($1.name ?? "") }
                .map { c in "\(c.name ?? "Contato") \(c.description)" }
            return mapped.joined(separator: "\n")
        }()

        return [
            ("Nome", name),
            ("Data de Nascimento", "\(dobStr)\(age)"),
            ("Peso", weight),
            ("Altura", height),
            ("Endereço", address),
            ("Contatos", contacts)
        ]
    }

    private func buildHealthProblemsRows(from r: CareRecipient) -> [InfoRow] {
        let hp = r.healthProblems
        let diseasesList: String = {
            if let set = hp?.diseases as? Set<Disease>, !set.isEmpty {
                let names = set.compactMap { $0.name }.sorted()
                return names.map { "• \($0)" }.joined(separator: "\n")
            }
            return "—"
        }()
        let surgeries = (hp?.surgery as? [String])?.joined(separator: "\n") ?? "—"
        let allergies = (hp?.allergies as? [String])?.joined(separator: ", ") ?? "—"
        let obs = hp?.observation ?? "—"

        return [
            ("Doenças", diseasesList),
            ("Cirurgias", surgeries),
            ("Alergias", allergies),
            ("Observação", obs)
        ]
    }

    private func buildPhysicalStateRows(from r: CareRecipient) -> [InfoRow] {
        let ph = r.physicalState
        return [
            ("Visão", ph?.visionState ?? "—"),
            ("Audição", ph?.hearingState ?? "—"),
            ("Locomoção", ph?.mobilityState ?? "—"),
            ("Saúde bucal", ph?.oralHealthState ?? "—")
        ]
    }

    private func buildMentalStateRows(from r: CareRecipient) -> [InfoRow] {
        let m = r.mentalState
        return [
            ("Comportamento", m?.emotionalState ?? "—"),
            ("Orientação", m?.orientationState ?? "—"),
            ("Memória", m?.memoryState ?? "—"),
            ("Cognição", m?.cognitionState ?? "—")
        ]
    }

    private func buildPersonalCareRows(from r: CareRecipient) -> [InfoRow] {
        let pc = r.personalCare
        let equipments = (pc?.equipmentState ?? "")
            .split(separator: ",")
            .map { "• " + $0.trimmingCharacters(in: .whitespaces) }
            .joined(separator: "\n")
        return [
            ("Banho", pc?.bathState ?? "—"),
            ("Higiene", pc?.hygieneState ?? "—"),
            ("Excreção", pc?.excretionState ?? "—"),
            ("Alimentação", pc?.feedingState ?? "—"),
            ("Equipamentos", equipments.isEmpty ? "—" : equipments)
        ]
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

    // MARK: - Builders de Texto (Data → String)
    private func buildPersonalDataText(from r: CareRecipient) -> String {
        let p = r.personalData
        let name = p?.name ?? "—"
        let address = p?.address ?? "—"
        let dob = p?.dateOfBirth
        let age = dob.map { " (\(Date().yearsSince($0)) anos)" } ?? ""
        let dobStr = dob?.formattedBR() ?? "—"
        let weight: String
        if let w = r.personalData?.weight { weight = "\(w.clean) Kg" } else { weight = "—" }

        let height: String
        if let h = r.personalData?.height { height = "\(h.clean) m" } else { height = "—" }

        let contacts: String = {
            guard let set = r.personalData?.contacts as? Set<Contact>, !set.isEmpty else { return "—" }
            let mapped = set
                .sorted { ($0.name ?? "") < ($1.name ?? "") }
                .map { c in
                    let n = c.name ?? "Contato"
                    let ph = c.description
                    return "\(n) \(ph)"
                }
            return mapped.joined(separator: "\n")
        }()

        return """
        Nome: \(name)
        Data de Nascimento: \(dobStr)\(age)      Peso: \(weight)      Altura: \(height)
        Endereço: \(address)
        Contatos:
        \(contacts)
        """
    }

    private func buildHealthProblemsText(from r: CareRecipient) -> String {
        let hp = r.healthProblems
        let diseasesList: String = {
            if let set = hp?.diseases as? Set<Disease>, !set.isEmpty {
                let names = set.compactMap { $0.name }.sorted()
                return names.map { "• \($0)" }.joined(separator: "\n")
            }
            return "—"
        }()
        let surgeries = (hp?.surgery as? [String])?.joined(separator: "\n") ?? "—"
        let allergies = (hp?.allergies as? [String])?.joined(separator: ", ") ?? "—"
        let obs = hp?.observation ?? "—"

        return """
        Doenças:
        \(diseasesList)

        Cirurgias
        \(surgeries)

        Alergias
        \(allergies)

        Observação
        \(obs)
        """
    }

    private func buildPhysicalStateText(from r: CareRecipient) -> String {
        let ph = r.physicalState
        return """
        Visão: \(ph?.visionState ?? "—")
        Audição: \(ph?.hearingState ?? "—")
        Locomoção: \(ph?.mobilityState ?? "—")
        Saúde bucal: \(ph?.oralHealthState ?? "—")
        """
    }

    private func buildMentalStateText(from r: CareRecipient) -> String {
        let m = r.mentalState
        return """
        Comportamento: \(m?.emotionalState ?? "—")
        Orientação: \(m?.orientationState ?? "—")
        Memória: \(m?.memoryState ?? "—")
        Cognição: \(m?.cognitionState ?? "—")
        """
    }

    private func buildPersonalCareText(from r: CareRecipient) -> String {
        let pc = r.personalCare
        let equipments = (pc?.equipmentState ?? "")
            .split(separator: ",")
            .map { "• \($0.trimmingCharacters(in: .whitespaces))" }
            .joined(separator: "\n")
        return """
        Banho: \(pc?.bathState ?? "—")
        Higiene: \(pc?.hygieneState ?? "—")
        Excreção: \(pc?.excretionState ?? "—")
        Alimentação: \(pc?.feedingState ?? "—")

        Equipamentos
        \(equipments.isEmpty ? "—" : equipments)
        """
    }

    // MARK: - Completion %
    private func completionPercent(for r: CareRecipient) -> CGFloat {
        var total = 0, filled = 0

        func check(_ value: String?) { total += 1; if let v = value, !v.trimmingCharacters(in: .whitespaces).isEmpty { filled += 1 } }
        func checkD(_ value: Date?) { total += 1; if value != nil { filled += 1 } }
        func checkN(_ value: NSNumber?) { total += 1; if value != nil { filled += 1 } }
        func checkDbl(_ value: Double?) { total += 1; if let v = value, !v.isNaN { filled += 1 } }
        func checkArr(_ value: Any?) { total += 1; if let a = value as? [Any], !a.isEmpty { filled += 1 } }

        let pd = r.personalData
        check(pd?.name); check(pd?.address); check(pd?.gender)
        checkD(pd?.dateOfBirth); checkDbl(pd?.height); checkDbl(pd?.weight)

        let hp = r.healthProblems
        check(hp?.observation); checkArr(hp?.allergies); checkArr(hp?.surgery)

        let m = r.mentalState
        check(m?.cognitionState); check(m?.emotionalState); check(m?.memoryState); check(m?.orientationState)

        let ph = r.physicalState
        check(ph?.mobilityState); check(ph?.hearingState); check(ph?.visionState); check(ph?.oralHealthState)

        let pc = r.personalCare
        check(pc?.bathState); check(pc?.hygieneState); check(pc?.excretionState); check(pc?.feedingState); check(pc?.equipmentState)

        guard total > 0 else { return 0.0 }
        return CGFloat(Double(filled) / Double(total))
    }

    // MARK: - Mock (o seu mesmo, sem mudanças)
    private func createMockPerson() {
        let stack = CoreDataStack.shared
        let service = CoreDataService(stack: stack)

        let personalData = PersonalData(context: stack.context)
        personalData.name = "Raissa Parente"
        personalData.address = "Rua das Acácias, 123 - Fortaleza, CE"
        personalData.gender = "Feminino"
        personalData.dateOfBirth = Calendar.current.date(from: DateComponents(year: 1957, month: 8, day: 15))
        personalData.height = 1.62
        personalData.weight = 64.5

        let health = HealthProblems(context: stack.context)
        health.allergies = ["Pólen", "Poeira (Rinite)"]
        health.surgery = ["Redução de Estômago — 12/06/2003"]
        health.observation = "Queda em 21/03/2021, fraturou o braço"

        let mental = MentalState(context: stack.context)
        mental.cognitionState = "Baixa capacidade"
        mental.memoryState = "Esquecimento frequente"
        mental.emotionalState = "Deprimido | Calmo"
        mental.orientationState = "Desorientação em espaço, tempo, pessoas"

        let physical = PhysicalState(context: stack.context)
        physical.mobilityState = "Acamado sem movimentação"
        physical.hearingState = "Comprometida"
        physical.visionState = "Completa"
        physical.oralHealthState = "Uso de prótese dentária"

        let care = PersonalCare(context: stack.context)
        care.bathState = "Ajuda parcial"
        care.hygieneState = "Baixa dependência"
        care.excretionState = "Usa fralda"
        care.feedingState = "Alimentação pastosa"
        care.equipmentState = "Sonda, Bolsa de colostomia, Soro intravenoso"

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

// MARK: - Utils
private extension Date {
    func yearsSince(_ other: Date) -> Int {
        Calendar.current.dateComponents([.year], from: other, to: self).year ?? 0
    }
    func formattedBR() -> String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "pt_BR")
        f.dateFormat = "dd/MM/yyyy"
        return f.string(from: self)
    }
}

private extension Double {
    var clean: String {
        let s = String(format: "%.2f", self)
        return s.replacingOccurrences(of: ".", with: ",")
    }
}

#Preview {
    UINavigationController(rootViewController: MedicalRecordViewController())
}
