//
//  EditMedicalRecordViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 30/10/25.
//

import UIKit

final class EditMedicalRecordViewController: GradientNavBarViewController, MedicalRecordSectionSelectorViewDelegate {
    let viewModel: EditMedicalRecordViewModel
    weak var delegate: EditMedicalRecordViewControllerDelegate?
    
    // O que é: instâncias das SUAS views, agora como UIViews puras.
    // Como faz: criamos as duas views com o mesmo viewModel, prontas para serem exibidas.
    // Por que faz: permite alternar sem navegação e sem view controllers filhos.
    private lazy var editPersonalDataView = EditPersonalDataView(viewModel: viewModel)
    private lazy var editPersonalCareView = EditPersonalCareView(viewModel: viewModel)

    // O que é: referência para a subview atualmente visível.
    // Como faz: guardamos para remover antes de adicionar a próxima.
    // Por que faz: evita sobreposição de views.
    private var currentContentView: UIView?

    private let contentContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Substitui o picker: agora usamos o nosso seletor com ícones
    private lazy var sectionSelectorView: MedicalRecordSectionSelectorView = {
        // O que faz: cria o seletor com os símbolos desejados e índice inicial 0.
        // Como faz: injeta delegate para ser notificado na seleção.
        // Por que faz: centraliza a escolha da seção sem navegação.
        let selector = MedicalRecordSectionSelectorView(
            symbolNames: ["person.fill", "heart.fill", "figure.arms.open", "brain.head.profile", "hand.raised.fill"],
            initialSelectedIndex: 0
        )
        selector.delegate = self
        return selector
    }()

    private let headerView: EditSectionHeaderView = {
        let header = EditSectionHeaderView(
            sectionTitle: "Prontuário",
            sectionDescription: "Selecione abaixo qual seção deseja editar sem sair desta tela.",
            sectionIcon: "doc.text.fill"
        )
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()

    init(viewModel: EditMedicalRecordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .pureWhite

        // Layout básico: seletor em cima, conteúdo embaixo
        view.addSubview(sectionSelectorView)
        view.addSubview(contentContainerView)

        NSLayoutConstraint.activate([
            sectionSelectorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            sectionSelectorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            sectionSelectorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            contentContainerView.topAnchor.constraint(equalTo: sectionSelectorView.bottomAnchor, constant: 20),
            contentContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Exibe o primeiro conteúdo por padrão
        displaySection(editPersonalDataView)
    }

    private func setupLayout() {
        view.addSubview(headerView)
        view.addSubview(contentContainerView)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//
//            contentContainerView.topAnchor.constraint(equalTo: sectionSelectorButton.bottomAnchor, constant: 20),
            contentContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // Delegate do seletor: mapeia índice → view correspondente e troca no container
    func medicalRecordSectionSelectorView(_ selectorView: MedicalRecordSectionSelectorView, didSelectIndex index: Int) {
        // O que faz: executa o “switch” pelo índice vindo do componente.
        // Como faz: decide qual UIView usar e chama displaySection.
        // Por que faz: reproduz exatamente a ideia do switch do SwiftUI.
        switch index {
        case 0: displaySection(editPersonalDataView)
        case 1: displaySection(editPersonalCareView)
        case 2: displaySection(editPersonalCareView) // exemplo: mapeie para outras views quando existirem
        case 3: displaySection(editPersonalCareView)
        case 4: displaySection(editPersonalCareView)
        default: displaySection(editPersonalDataView)
        }
    }

    private func displaySection(_ newContentView: UIView) {
        // O que faz: troca a subview exibida dentro do container.
        // Como faz: remove a atual (se houver), adiciona a nova e ancora por Auto Layout.
        // Por que faz: idêntico ao switch do SwiftUI, mas com UIViews.
        if let currentContentView {
            currentContentView.removeFromSuperview()
        }

        contentContainerView.addSubview(newContentView)
        newContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newContentView.topAnchor.constraint(equalTo: contentContainerView.topAnchor),
            newContentView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor),
            newContentView.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor),
            newContentView.bottomAnchor.constraint(equalTo: contentContainerView.bottomAnchor)
        ])

        currentContentView = newContentView
        view.layoutIfNeeded()
    }
}
