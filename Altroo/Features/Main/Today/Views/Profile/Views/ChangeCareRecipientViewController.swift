//
//  ChangeCareRecipientViewController.swift
//  Altroo
//
//  Created by Raissa Parente on 02/10/25.
//
import UIKit

final class ChangeCareRecipientViewController: UIViewController {
    let viewModel: ChangeCareRecipientViewModel
    
       init(viewModel: ChangeCareRecipientViewModel) {
           self.viewModel = viewModel
           super.init(nibName: nil, bundle: nil) 
       }

       @available(*, unavailable)
       required init?(coder: NSCoder) {
           fatalError("Use init(viewModel:) em vez de init(coder:)")
       }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavigation()
        buildLayout()
    }

    // MARK: - Navigation
    private func configureNavigation() {
        navigationItem.title = "Seus Assistidos"

        let close = UIBarButtonItem(title: "Fechar", style: .plain, target: self, action: #selector(closeTapped))
        navigationItem.leftBarButtonItem = close
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    // MARK: - Build
    private func buildLayout() {
        let scroll = makeScrollArea()
        let bottomBar = makeBottomBar()

        view.addSubview(scroll.container)
        view.addSubview(bottomBar.container)

        NSLayoutConstraint.activate([
            scroll.container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scroll.container.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.container.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.container.bottomAnchor.constraint(equalTo: bottomBar.container.topAnchor),

            bottomBar.container.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBar.container.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBar.container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        let cardsStack = makeCardsStack()
        scroll.stack.addArrangedSubview(cardsStack)

        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.heightAnchor.constraint(equalToConstant: 24).isActive = true
        scroll.stack.addArrangedSubview(spacer)
    }


    private func makeScrollArea() -> (container: UIScrollView, stack: UIStackView) {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.alwaysBounceVertical = true
        scroll.keyboardDismissMode = .onDrag

        let content = UIView()
        content.translatesAutoresizingMaskIntoConstraints = false

        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
        stack.isLayoutMarginsRelativeArrangement = true

        view.addSubview(scroll)
        scroll.addSubview(content)
        content.addSubview(stack)

        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor),
            content.leadingAnchor.constraint(equalTo: scroll.contentLayoutGuide.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: scroll.contentLayoutGuide.trailingAnchor),
            content.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor),

            content.widthAnchor.constraint(equalTo: scroll.frameLayoutGuide.widthAnchor),

            stack.topAnchor.constraint(equalTo: content.topAnchor),
            stack.leadingAnchor.constraint(equalTo: content.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: content.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: content.bottomAnchor)
        ])

        return (scroll, stack)
    }

    private func makeBottomBar() -> (container: UIView, addButton: UIButton, linkButton: UIButton) {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .clear

        let addButton = UIButton(type: .system)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setTitle("Adicionar", for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        addButton.setTitleColor(.white, for: .normal)
        addButton.backgroundColor = UIColor.systemTeal
        addButton.layer.cornerCurve = .continuous
        addButton.layer.cornerRadius = 20
        addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)

        let link = UIButton(type: .system)
        link.translatesAutoresizingMaskIntoConstraints = false
        link.setTitle("Já tenho uma pessoa cadastrada", for: .normal)
        link.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        link.setTitleColor(UIColor.systemTeal, for: .normal)
        link.addTarget(self, action: #selector(linkTapped), for: .touchUpInside)

        container.addSubview(addButton)
        container.addSubview(link)

        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            addButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 24),
            addButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -24),
            addButton.heightAnchor.constraint(equalToConstant: 56),

            link.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 12),
            link.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            link.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8)
        ])

        return (container, addButton, link)
    }

    private func makeCardsStack() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false

        let data = viewModel.fetchAvailableCareRecipients()

        for (index, careRecipient) in data.enumerated() {
            let card = makeRecipientCard(
                name: careRecipient.personalData?.name ?? "Nome não informado",
                age: careRecipient.personalData?.age ?? 0,
                initials: initialsFromName(careRecipient.personalData?.name ?? "")
            )
            card.tag = index
            stack.addArrangedSubview(card)
        }

        return stack
    }

    private func makeRecipientCard(name: String, age: Int, initials: String) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.08)
        container.layer.cornerCurve = .continuous
        container.layer.cornerRadius = 14

        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.spacing = 14
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.layoutMargins = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        hStack.isLayoutMarginsRelativeArrangement = true

        let avatar = makeAvatar(initials: initials)

        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = name
        title.textColor = UIColor.systemBlue
        title.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        let subtitle = UILabel()
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.text = "\(age) anos"
        subtitle.textColor = UIColor.secondaryLabel
        subtitle.font = UIFont.systemFont(ofSize: 18, weight: .regular)

        let vStack = UIStackView(arrangedSubviews: [title, subtitle])
        vStack.axis = .vertical
        vStack.alignment = .leading
        vStack.spacing = 2
        vStack.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(hStack)
        hStack.addArrangedSubview(avatar)
        hStack.addArrangedSubview(vStack)

        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: container.topAnchor),
            hStack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            hStack.bottomAnchor.constraint(equalTo: container.bottomAnchor),

            avatar.widthAnchor.constraint(equalToConstant: 64),
            avatar.heightAnchor.constraint(equalToConstant: 64)
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(cardTapped(_:)))
        container.addGestureRecognizer(tap)

        return container
    }

    private func makeAvatar(initials: String) -> UIView {
        let circle = UIView()
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.backgroundColor = UIColor.systemBlue
        circle.layer.cornerCurve = .continuous
        circle.layer.cornerRadius = 32
        circle.layer.masksToBounds = true

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = initials
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)

        circle.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: circle.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: circle.centerYAnchor)
        ])

        return circle
    }

    func initialsFromName(_ name: String) -> String {
        let comps = name.split(separator: " ")
        let initials = comps.prefix(2).compactMap { $0.first?.uppercased() }.joined()
        return initials.isEmpty ? "?" : initials
    }
    
    // MARK: - Actions
    @objc private func closeTapped() {
        dismiss(animated: true)
    }

    @objc private func addTapped() {
        print("Add tapped")
    }

    @objc private func linkTapped() {
        print("Link tappd")
    }

    @objc private func cardTapped(_ gesture: UITapGestureRecognizer) {
        guard let view = gesture.view else { return }
        let allRecipients = viewModel.fetchAvailableCareRecipients()
        guard view.tag < allRecipients.count else { return }

        let selected = allRecipients[view.tag]
        viewModel.changeCurrentCareRecipient(newCurrentPatient: selected)
        dismiss(animated: true)
    }
}

//#Preview {
//    ChangeCareRecipientViewController()
//}
