//
//  SelectSectionButtonsRowView.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 30/10/25.
//
import UIKit

// MARK: - Protocolo de Delegate para notificar seleção
// O que é: uma forma desacoplada de avisar ao container que o índice mudou.
// Como faz: envia o índice selecionado sempre que o usuário toca em um item ou nas setas.
// Por que faz: permite que o container decida qual UIView mostrar (switch), sem dependências cíclicas.
protocol MedicalRecordSectionSelectorViewDelegate: AnyObject {
    func medicalRecordSectionSelectorView(_ selectorView: MedicalRecordSectionSelectorView, didSelectIndex index: Int)
}

// MARK: - Botão circular com ícone e estado selecionado
// O que é: UIButton especializado para renderizar um círculo com um ícone central.
// Como faz: altera cores de fundo e do ícone conforme a propriedade isSelectedItem.
// Por que faz: encapsula o visual e o comportamento para reaproveitar com qualquer ícone.
final class CircleIconSelectableButton: UIButton {
    // Cores de acordo com seu layout
    private let selectedBackgroundColor = UIColor.systemBlue
    private let unselectedBackgroundColor = UIColor.systemBlue.withAlphaComponent(0.3)
    private let selectedIconColor = UIColor.white
    private let unselectedIconColor = UIColor.white

    // Mantém um símbolo SF configurado
    private let symbolName: String
    private let symbolPointSize: CGFloat

    // Índice atrelado ao botão (quem usa sabe qual posição ele representa)
    let itemIndex: Int

    // O que é: estado visual do item.
    // Como faz: atualiza background e tintColor ao ser modificado.
    // Por que faz: feedback claro de qual ícone está ativo.
    var isSelectedItem: Bool = false {
        didSet { updateVisualState() }
    }

    init(symbolName: String, symbolPointSize: CGFloat, itemIndex: Int) {
        self.symbolName = symbolName
        self.symbolPointSize = symbolPointSize
        self.itemIndex = itemIndex
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupVisual()
        updateVisualState()
        isAccessibilityElement = true
        accessibilityTraits = .button
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupVisual() {
        // O que faz: cria a imagem SF Symbol com peso apropriado.
        // Como faz: usa UIImage.SymbolConfiguration para tamanho consistente do ícone.
        // Por que faz: mantém coerência visual e legibilidade em diferentes telas.
        let configuration = UIImage.SymbolConfiguration(pointSize: symbolPointSize, weight: .semibold)
        let image = UIImage(systemName: symbolName, withConfiguration: configuration)
        setImage(image, for: .normal)

        // O que faz: define visual circular.
        // Como faz: aplica cornerRadius ao layer e define contentEdgeInsets para respiro interno.
        // Por que faz: replica o formato “badge” circular da referência.
        backgroundColor = unselectedBackgroundColor
        tintColor = unselectedIconColor
        layer.cornerRadius = 36 // ajustado para bater com 72x72 abaixo
        clipsToBounds = true
        contentEdgeInsets = UIEdgeInsets(top: 18, left: 18, bottom: 18, right: 18)

        // Tamanho fixo (ajuste se quiser responsivo)
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 72),
            widthAnchor.constraint(equalToConstant: 72)
        ])
    }

    private func updateVisualState() {
        backgroundColor = isSelectedItem ? selectedBackgroundColor : unselectedBackgroundColor
        tintColor = isSelectedItem ? selectedIconColor : unselectedIconColor
        accessibilityValue = isSelectedItem ? "Selecionado" : "Não selecionado"
    }
}

// MARK: - Barra com setas e ícones
// O que é: a view principal que mostra seta esquerda, lista de ícones circulares e seta direita.
// Como faz: usa UIStackView para layout horizontal com espaçamento uniforme. Controla o índice atual e notifica o delegate.
// Por que faz: componente único para controlar “em qual seção estamos”, substituindo o picker atual.
final class MedicalRecordSectionSelectorView: UIView {

    weak var delegate: MedicalRecordSectionSelectorViewDelegate?

    // Ícones default (você pode injetar outros via init).
    // Mantive símbolos coerentes com a imagem: pessoa, coração, figura humana, cérebro, mão.
    private let symbolNames: [String]

    // Botões criados a partir dos símbolos
    private var iconButtons: [CircleIconSelectableButton] = []

    // Índice atualmente selecionado
    private(set) var selectedIndex: Int = 0 {
        didSet {
            updateSelectionAppearance()
            // Notifica quem precisa trocar a view apresentada
            delegate?.medicalRecordSectionSelectorView(self, didSelectIndex: selectedIndex)
        }
    }

    // Setas de navegação lateral
    private lazy var leftArrowButton: UIButton = {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 26, weight: .semibold)
        let image = UIImage(systemName: "arrow.left", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleLeftArrowTap), for: .touchUpInside)
        button.accessibilityLabel = "Anterior"
        return button
    }()

    private lazy var rightArrowButton: UIButton = {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 26, weight: .semibold)
        let image = UIImage(systemName: "arrow.right", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleRightArrowTap), for: .touchUpInside)
        button.accessibilityLabel = "Próximo"
        return button
    }()

    // Stack que contém as setas e os ícones
    private let mainHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // Inicializador designado que permite injetar símbolos customizados e índice inicial
    init(symbolNames: [String] = ["person.fill", "heart.fill", "figure.arms.open", "brain.head.profile", "hand.raised.fill"],
         initialSelectedIndex: Int = 0) {
        self.symbolNames = symbolNames
        self.selectedIndex = max(0, min(initialSelectedIndex, symbolNames.count - 1))
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupLayoutAndBuildButtons()
        updateSelectionAppearance() // O que faz: aplica estado visual ao selecionado inicial.
        isAccessibilityElement = false // elementos internos já são acessíveis
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupLayoutAndBuildButtons() {
        // O que faz: adiciona seta esquerda, ícones e seta direita ao stack principal.
        // Como faz: cria um botão circular para cada símbolo e conecta target de toque.
        // Por que faz: construção declarativa, simples de manter.
        addSubview(mainHorizontalStackView)
        NSLayoutConstraint.activate([
            mainHorizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainHorizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            mainHorizontalStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            mainHorizontalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])

        mainHorizontalStackView.addArrangedSubview(leftArrowButton)

        iconButtons = symbolNames.enumerated().map { (index, symbol) in
            let button = CircleIconSelectableButton(symbolName: symbol, symbolPointSize: 26, itemIndex: index)
            button.addTarget(self, action: #selector(handleIconTap(_:)), for: .touchUpInside)
            button.accessibilityLabel = "Item \(index + 1)"
            return button
        }

        // Espaçamento visual uniforme
        let iconsHorizontalStackView = UIStackView(arrangedSubviews: iconButtons)
        iconsHorizontalStackView.axis = .horizontal
        iconsHorizontalStackView.alignment = .center
        iconsHorizontalStackView.distribution = .equalSpacing
        iconsHorizontalStackView.spacing = 24
        iconsHorizontalStackView.translatesAutoresizingMaskIntoConstraints = false

        mainHorizontalStackView.addArrangedSubview(iconsHorizontalStackView)
        mainHorizontalStackView.addArrangedSubview(rightArrowButton)
    }

    private func updateSelectionAppearance() {
        // O que faz: atualiza o estado visual de todos os ícones conforme selectedIndex.
        // Como faz: itera pelos botões e marca true apenas o que corresponde ao índice atual.
        // Por que faz: feedback claro de qual item está ativo.
        for (index, button) in iconButtons.enumerated() {
            button.isSelectedItem = (index == selectedIndex)
        }
    }

    @objc private func handleIconTap(_ sender: CircleIconSelectableButton) {
        // O que faz: seleção direta ao tocar em um ícone.
        // Como faz: atualiza selectedIndex, que por sua vez notifica o delegate.
        // Por que faz: interação imediata e previsível.
        guard sender.itemIndex != selectedIndex else { return }
        selectedIndex = sender.itemIndex
    }

    @objc private func handleLeftArrowTap() {
        // O que faz: move a seleção para o item anterior com rotação opcional (loop).
        // Como faz: decrementa o índice e aplica módulo no total.
        // Por que faz: facilita navegação por setas como no design mostrado.
        let total = iconButtons.count
        guard total > 0 else { return }
        selectedIndex = (selectedIndex - 1 + total) % total
    }

    @objc private func handleRightArrowTap() {
        let total = iconButtons.count
        guard total > 0 else { return }
        selectedIndex = (selectedIndex + 1) % total
    }
}
