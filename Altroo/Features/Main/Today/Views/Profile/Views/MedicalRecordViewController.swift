//
//  MedicalRecordViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 11/10/25.
//

import UIKit

final class MedicalRecordViewController: GradientNavBarViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }

    private func setupLayout() {
        view.backgroundColor = .white

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
        content.spacing = 16
        content.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(content)

        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            content.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            content.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            content.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -40),
            content.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
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
        container.backgroundColor = .white

        let title = StandardLabel(
            labelText: "Ficha Médica",
            labelFont: .sfPro,
            labelType: .title1,
            labelColor: .black10,
            labelWeight: .semibold
        )

        let subtitle = StandardLabel(
            labelText: "Reúna as informações de saúde do assistido em um só lugar, de forma simples e acessível.",
            labelFont: .sfPro,
            labelType: .footnote,
            labelColor: .gray,
            labelWeight: .regular
        )
        subtitle.numberOfLines = 0

        let progress = UIProgressView(progressViewStyle: .default)
        progress.progress = 0.8
        progress.trackTintColor = .gray
        progress.progressTintColor = .teal20
        progress.translatesAutoresizingMaskIntoConstraints = false

        let percent = StandardLabel(
            labelText: "80%",
            labelFont: .sfPro,
            labelType: .footnote,
            labelColor: .teal20,
            labelWeight: .semibold
        )

        let progressRow = UIStackView(arrangedSubviews: [progress, percent])
        progressRow.axis = .horizontal
        progressRow.alignment = .center
        progressRow.spacing = 8

        let date = StandardLabel(
            labelText: "Atualizada em: 28/10/2025",
            labelFont: .sfPro,
            labelType: .footnote,
            labelColor: .gray,
            labelWeight: .regular
        )

        let stack = UIStackView(arrangedSubviews: [title, subtitle, progressRow, date])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: container.topAnchor),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])

        return container
    }

    // MARK: - Aviso + botão
    private func makeCompletionAlertAndButton() -> UIView {
        let wrapper = UIStackView()
        wrapper.axis = .vertical
        wrapper.spacing = 12
        wrapper.translatesAutoresizingMaskIntoConstraints = false

        let alertBox = UIView()
        alertBox.backgroundColor = UIColor.teal0.withAlphaComponent(0.15)
        alertBox.layer.cornerRadius = 8

        let icon = UIImageView(image: UIImage(systemName: "exclamationmark.triangle.fill"))
        icon.tintColor = .teal20
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.widthAnchor.constraint(equalToConstant: 20).isActive = true

        let label = StandardLabel(
            labelText: "Finalize o preenchimento para ter os dados de saúde do paciente à mão quando precisar.",
            labelFont: .sfPro,
            labelType: .footnote,
            labelColor: .black10,
            labelWeight: .regular
        )
        label.numberOfLines = 0

        let alertStack = UIStackView(arrangedSubviews: [icon, label])
        alertStack.axis = .horizontal
        alertStack.alignment = .top
        alertStack.spacing = 8
        alertStack.translatesAutoresizingMaskIntoConstraints = false

        alertBox.addSubview(alertStack)
        NSLayoutConstraint.activate([
            alertStack.topAnchor.constraint(equalTo: alertBox.topAnchor, constant: 12),
            alertStack.bottomAnchor.constraint(equalTo: alertBox.bottomAnchor, constant: -12),
            alertStack.leadingAnchor.constraint(equalTo: alertBox.leadingAnchor, constant: 12),
            alertStack.trailingAnchor.constraint(equalTo: alertBox.trailingAnchor, constant: -12)
        ])

        let editButton = makeFilledButton(icon: UIImage(systemName: "square.and.pencil"), title: "Editar Ficha Médica")
        wrapper.addArrangedSubview(alertBox)
        wrapper.addArrangedSubview(editButton)

        return wrapper
    }

    // MARK: - Cards / Seções
    private func makeSection(title: String, content: String) -> UIView {
        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 10
        container.layer.shadowColor = UIColor.black.withAlphaComponent(0.05).cgColor
        container.layer.shadowOpacity = 1
        container.layer.shadowRadius = 4
        container.layer.shadowOffset = CGSize(width: 0, height: 1)

        let header = UIView()
        header.backgroundColor = UIColor.teal10
        header.layer.cornerRadius = 8
        header.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = StandardLabel(
            labelText: title,
            labelFont: .sfPro,
            labelType: .callOut,
            labelColor: .white,
            labelWeight: .semibold
        )
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        header.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: header.centerYAnchor)
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
}

#Preview {
    UINavigationController(rootViewController: MedicalRecordViewController())
}
