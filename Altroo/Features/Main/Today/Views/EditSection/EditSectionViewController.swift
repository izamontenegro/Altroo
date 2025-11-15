//
//  EditSectionViewController.swift
//  Altroo
//
//  Created by Raissa Parente on 02/10/25.
//

import UIKit

class EditSectionViewController: GradientNavBarViewController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .pureWhite
        
        setupLayout()
        setupItems()
    }

    // MARK: - Subviews
    private let header = StandardHeaderView(title: "Editar Seção", subtitle: "Reordene ou oculte seção para personalizar a visualização.")
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Layout
    private func setupLayout() {
        let mainStack = setupMainLayout()
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.mediumSpacing),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.mediumSpacing),
            mainStack.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -Layout.mediumSpacing)
        ])
    }
    
    private func setupMainLayout() -> UIView {
        let mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.spacing = 16
        
        mainStack.addArrangedSubview(header)
        mainStack.addArrangedSubview(stackView)

        return mainStack
    }
    
    // MARK: - Items
    private func setupItems() {
        let configs = TodaySectionManager.shared.load()

        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        for config in configs {
            switch config.type {
            case .basicNeeds:
                let items = config.subitems?.map(\.title) ?? ["Alimentação", "Hidratação", "Fezes", "Urina"]
                let sectionView = makeSection(
                    title: "Necessidades Básicas",
                    checked: config.isVisible,
                    items: items,
                    subitemStates: config.subitems
                )
                stackView.addArrangedSubview(sectionView)

            case .tasks:
                let sectionView = makeSection(title: "Tarefas", checked: config.isVisible, items: nil)
                stackView.addArrangedSubview(sectionView)

            case .intercurrences:
                let sectionView = makeSection(title: "Intercorrências", checked: config.isVisible, items: nil)
                stackView.addArrangedSubview(sectionView)
            }
        }
    }
    
    private func makeSection(title: String, checked: Bool, items: [String]?, subitemStates: [SubitemConfig]? = nil) -> UIStackView {
        let sectionStack = UIStackView()
        sectionStack.axis = .vertical
        sectionStack.spacing = 8
        sectionStack.isLayoutMarginsRelativeArrangement = true
        sectionStack.layoutMargins = UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0)
        
        let headerStack = UIStackView()
        headerStack.axis = .horizontal
        headerStack.alignment = .center
        headerStack.spacing = 8
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        
        let checkmark = UIImageView(image: UIImage(systemName: checked ? "checkmark.circle.fill" : "circle"))
        checkmark.tintColor = UIColor(resource: .teal20)
        checkmark.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkmark.widthAnchor.constraint(equalToConstant: 24),
            checkmark.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        let label = StandardLabel(
            labelText: title,
            labelFont: .sfPro,
            labelType: .title3,
            labelColor: .black10,
            labelWeight: .semibold
        )
        
        let dragIcon = UIImageView(image: UIImage(systemName: "line.3.horizontal"))
        dragIcon.tintColor = .black10
        dragIcon.isUserInteractionEnabled = true
        NSLayoutConstraint.activate([
            dragIcon.widthAnchor.constraint(equalToConstant: 24),
            dragIcon.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleDrag(_:)))
        longPress.minimumPressDuration = 0.2
        dragIcon.addGestureRecognizer(longPress)
        
        headerStack.addArrangedSubview(checkmark)
        headerStack.addArrangedSubview(label)
        headerStack.addArrangedSubview(UIView())
        headerStack.addArrangedSubview(dragIcon)
        
        headerStack.isUserInteractionEnabled = true
        let headerTap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        headerStack.addGestureRecognizer(headerTap)
        headerStack.tag = 1000
        checkmark.tag = 999
        
        sectionStack.addArrangedSubview(headerStack)
        
        // Subitens
        if let items = items {
            for item in items {
                let isVisible = subitemStates?.first(where: { $0.title == item })?.isVisible ?? true
                
                let itemStack = UIStackView()
                itemStack.axis = .horizontal
                itemStack.alignment = .center
                itemStack.spacing = 8
                itemStack.isLayoutMarginsRelativeArrangement = true
                itemStack.layoutMargins = UIEdgeInsets(top: 6, left: 35, bottom: 6, right: 0)
                
                let itemCheck = UIImageView(image: UIImage(systemName: isVisible ? "checkmark.circle.fill" : "circle"))
                itemCheck.tintColor = UIColor(resource: .teal20)
                itemCheck.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    itemCheck.widthAnchor.constraint(equalToConstant: 24),
                    itemCheck.heightAnchor.constraint(equalToConstant: 24)
                ])
                
                let itemLabel = StandardLabel(
                    labelText: item,
                    labelFont: .sfPro,
                    labelType: .title3,
                    labelColor: .black10,
                    labelWeight: .regular
                )
                
                itemStack.addArrangedSubview(itemCheck)
                itemStack.addArrangedSubview(itemLabel)
                
                itemStack.isUserInteractionEnabled = true
                let itemTap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                itemStack.addGestureRecognizer(itemTap)
                itemCheck.tag = 999
                
                sectionStack.addArrangedSubview(itemStack)
            }
        }
        
        return sectionStack
    }

    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view else { return }

        guard let checkmark = tappedView.subviews
                .compactMap({ $0 as? UIImageView })
                .first(where: { $0.tag == 999 }) else { return }

        let isChecked = checkmark.image == UIImage(systemName: "checkmark.circle.fill")
        let newImageName = isChecked ? "circle" : "checkmark.circle.fill"
        checkmark.image = UIImage(systemName: newImageName)

        UIView.animate(withDuration: 0.15, animations: {
            checkmark.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            UIView.animate(withDuration: 0.15) {
                checkmark.transform = .identity
            }
        }

        guard let sectionStack = tappedView.superview as? UIStackView,
              let headerStack = sectionStack.arrangedSubviews.first as? UIStackView,
              let headerCheck = headerStack.subviews.compactMap({ $0 as? UIImageView }).first(where: { $0.tag == 999 }) else { return }

        let subitemStacks = sectionStack.arrangedSubviews.dropFirst()

        if tappedView == headerStack {
            for subview in subitemStacks {
                if let itemCheck = subview.subviews.compactMap({ $0 as? UIImageView }).first(where: { $0.tag == 999 }) {
                    itemCheck.image = UIImage(systemName: newImageName)
                }
            }
        } else {
            updateHeaderState(headerCheck: headerCheck, subitems: subitemStacks)
        }

        saveCurrentOrder()
    }

    private func updateHeaderState(headerCheck: UIImageView, subitems: ArraySlice<UIView>) {
        let anySubitemChecked = subitems.contains { subview in
            guard let itemCheck = subview.subviews.compactMap({ $0 as? UIImageView }).first(where: { $0.tag == 999 }) else { return false }
            return itemCheck.image == UIImage(systemName: "checkmark.circle.fill")
        }

        headerCheck.image = UIImage(systemName: anySubitemChecked ? "checkmark.circle.fill" : "circle")
    }
    @objc private func handleDrag(_ gesture: UILongPressGestureRecognizer) {
        guard let draggedView = gesture.view?.superview?.superview else { return }
        guard let stackView = draggedView.superview as? UIStackView else { return }
        
        switch gesture.state {
        case .began:
            UIView.animate(withDuration: 0.2) {
                draggedView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                draggedView.alpha = 0.8
            }
        case .changed:
            let location = gesture.location(in: stackView)
            for subview in stackView.arrangedSubviews {
                if subview != draggedView && subview.frame.contains(location) {
                    if let fromIndex = stackView.arrangedSubviews.firstIndex(of: draggedView),
                       let toIndex = stackView.arrangedSubviews.firstIndex(of: subview) {
                        stackView.removeArrangedSubview(draggedView)
                        stackView.insertArrangedSubview(draggedView, at: toIndex)
                        UIView.animate(withDuration: 0.2) {
                            stackView.layoutIfNeeded()
                        }
                    }
                    break
                }
            }
        case .ended, .cancelled:
            UIView.animate(withDuration: 0.2) {
                draggedView.transform = .identity
                draggedView.alpha = 1.0
            }
            saveCurrentOrder()
        default:
            break
        }
    }

    private func saveCurrentOrder() {
        var configs: [TodaySectionConfig] = []
        
        for (index, sectionView) in stackView.arrangedSubviews.enumerated() {
            guard
                let headerStack = sectionView.subviews.first(where: { $0.tag == 1000 }) as? UIStackView,
                let label = headerStack.arrangedSubviews.compactMap({ $0 as? UILabel }).first,
                let type = TodaySectionType(rawValue: label.text ?? "")
            else { continue }
            
            let checkmark = headerStack.arrangedSubviews.compactMap({ $0 as? UIImageView }).first(where: { $0.tag == 999 })
            let isVisible = checkmark?.image == UIImage(systemName: "checkmark.circle.fill")
            
            let subitems: [SubitemConfig]?
            if type == .basicNeeds, let sectionStack = sectionView as? UIStackView {
                subitems = sectionStack.arrangedSubviews.compactMap { subview in
                    guard
                        subview != headerStack,
                        let itemStack = subview as? UIStackView,
                        let itemLabel = itemStack.arrangedSubviews.compactMap({ $0 as? UILabel }).first,
                        let itemCheck = itemStack.arrangedSubviews.compactMap({ $0 as? UIImageView }).first(where: { $0.tag == 999 })
                    else { return nil }

                    return SubitemConfig(
                        title: itemLabel.text ?? "",
                        isVisible: itemCheck.image == UIImage(systemName: "checkmark.circle.fill")
                    )
                }
            } else {
                subitems = nil
            }

            configs.append(
                TodaySectionConfig(type: type, isVisible: isVisible, order: index, subitems: subitems)
            )
        }
        
        TodaySectionManager.shared.save(configs)
    }
}

//#Preview {
//    EditSectionViewController()
//}
