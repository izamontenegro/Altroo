//
//  SelectSectionButtonsRowView.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 30/10/25.
//
import UIKit

protocol MedicalRecordSectionSelectorViewDelegate: AnyObject {
    func medicalRecordSectionSelectorView(_ selectorView: MedicalRecordSectionSelectorView, didSelectIndex index: Int)
    func medicalRecordSectionSelectorView(_ selectorView: MedicalRecordSectionSelectorView, shouldChangeAppearanceTo index: Int) -> Bool
}

final class MedicalRecordSectionSelectorView: UIView {
    
    weak var delegate: MedicalRecordSectionSelectorViewDelegate?
    
    private let symbolNames: [String]
    private var iconButtons: [UIButton] = []
    private(set) var selectedIndex: Int = 0 {
        didSet {
            delegate?.medicalRecordSectionSelectorView(self, didSelectIndex: selectedIndex)
            updateSelectionAppearance()
        }
    }
    
    private lazy var leftArrowButton: UIButton = {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
        button.setImage(UIImage(systemName: "arrow.left", withConfiguration: configuration), for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleLeftArrowTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var rightArrowButton: UIButton = {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
        button.setImage(UIImage(systemName: "arrow.right", withConfiguration: configuration), for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleRightArrowTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var iconsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center
        stack.distribution = .equalCentering
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [leftArrowButton, iconsStackView, rightArrowButton])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 16
        stack.distribution = .equalCentering
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    init(symbolNames: [String] = ["person.fill", "heart.fill", "figure.arms.open", "brain.head.profile", "hand.raised.fill"],
         initialSelectedIndex: Int = 0) {
        self.symbolNames = symbolNames
        self.selectedIndex = initialSelectedIndex
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Setup
    private func setupUI() {
        addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        buildButtons()
        updateSelectionAppearance()
    }
    
    private func buildButtons() {
        for (index, symbol) in symbolNames.enumerated() {
            let button = UIButton(type: .system)
            let configuration = UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)
            let image = UIImage(systemName: symbol, withConfiguration: configuration)
            button.setImage(image, for: .normal)
            button.tintColor = .white
            button.backgroundColor = .systemBlue.withAlphaComponent(0.4)
            button.layer.cornerRadius = 15 // metade de 30
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tag = index
            button.addTarget(self, action: #selector(handleIconTap(_:)), for: .touchUpInside)
            
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 30),
                button.heightAnchor.constraint(equalToConstant: 30)
            ])
            
            iconsStackView.addArrangedSubview(button)
            iconButtons.append(button)
        }
    }
    
    private func updateSelectionAppearance() {
        for (index, button) in iconButtons.enumerated() {
            if index == selectedIndex {
                button.backgroundColor = .systemBlue
                button.tintColor = .white
            } else {
                button.backgroundColor = .systemBlue.withAlphaComponent(0.4)
                button.tintColor = .white
            }
        }
    }
    
    @objc private func handleIconTap(_ sender: UIButton) {
        guard sender.tag != selectedIndex else { return }
        
        let canSelect = delegate?.medicalRecordSectionSelectorView(self, shouldChangeAppearanceTo: selectedIndex) ?? true
        guard canSelect else { return }
        
        selectedIndex = sender.tag
    }
    
    @objc private func handleLeftArrowTap() {
        let canSelect = delegate?.medicalRecordSectionSelectorView(self, shouldChangeAppearanceTo: selectedIndex) ?? true
        guard canSelect else { return }
        
        selectedIndex = (selectedIndex - 1 + iconButtons.count) % iconButtons.count
    }
    
    @objc private func handleRightArrowTap() {
        let canSelect = delegate?.medicalRecordSectionSelectorView(self, shouldChangeAppearanceTo: selectedIndex) ?? true
        guard canSelect else { return }
        
        selectedIndex = (selectedIndex + 1) % iconButtons.count
    }
}
