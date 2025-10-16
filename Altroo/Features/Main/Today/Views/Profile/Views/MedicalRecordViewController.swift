//
//  MedicalRecordViewController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 11/10/25.
//

import UIKit
import Combine

final class MedicalRecordViewController: GradientNavBarViewController {
    
    let viewModel: MedicalRecordViewModel

    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: MedicalRecordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.reload()
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        bindViewModel()
    }

    // MARK: - Bindings
    private func bindViewModel() {
        viewModel.$sections
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.reloadContent()
            }
            .store(in: &cancellables)
    }

    // MARK: - Layout
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    private func setupLayout() {
        view.backgroundColor = .pureWhite

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        contentStack.axis = .vertical
        contentStack.spacing = 24
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30),
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -40),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        reloadContent()
    }

    // MARK: - Content reload
    private func reloadContent() {
        contentStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        contentStack.addArrangedSubview(makeHeaderSection(percent: viewModel.completionPercent))
        contentStack.addArrangedSubview(makeCompletionAlertAndButton())

        for section in viewModel.sections {
            contentStack.addArrangedSubview(makeSection(
                title: section.title,
                rows: section.rows,
                icon: section.iconSystemName
            ))
        }
    }

    // MARK: - Header
    func makeHeaderSection(percent: CGFloat) -> UIView {
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
        // Fallback imediato: já pinta algo mesmo sem gradient
        fill.backgroundColor = .blue10
        
        track.addSubview(fill)
        
        let percentLabel = StandardLabel(
            labelText: "\(Int(round(percent * 100)))%",
            labelFont: .sfPro,
            labelType: .callOut,
            labelColor: .blue20,
            labelWeight: .medium
        )
        
        let progressRow = UIStackView(arrangedSubviews: [track, percentLabel])
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
            fill.widthAnchor.constraint(equalTo: track.widthAnchor, multiplier: max(0, min(1, percent))),
            
            stack.topAnchor.constraint(equalTo: container.topAnchor),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        DispatchQueue.main.async {
            container.layoutIfNeeded()
            let gradient = CAGradientLayer()
            gradient.colors = [UIColor.blue10.cgColor, UIColor.blue50.cgColor]
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint =   CGPoint(x: 1.0, y: 0.5)
            gradient.frame = fill.bounds
            gradient.cornerRadius = fill.layer.cornerRadius
            fill.layer.insertSublayer(gradient, at: 0)
        }
        
        return container
    }

    // MARK: - Completion Alert
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

        let editButton = makeFilledButton(
            icon: UIImage(systemName: "square.and.pencil"),
            title: "Editar Ficha Médica"
        )

        wrapper.addArrangedSubview(alertBox)
        wrapper.addArrangedSubview(editButton)
        return wrapper
    }

    // MARK: - Section
    private func makeSection(title: String, rows: [InfoRow], icon: String) -> UIView {
        let container = UIView()
        container.backgroundColor = .clear

        let header = makeSectionHeader(title: title, icon: icon)

        let itemsStack = UIStackView()
        itemsStack.axis = .vertical
        itemsStack.spacing = 10
        itemsStack.translatesAutoresizingMaskIntoConstraints = false

        for row in rows {
            let item = MedicalRecordInfoItemView(
                infotitle: row.title,
                infoDescription: row.value
            )
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

    private func makeSectionHeader(title: String, icon: String) -> UIView {
        let header = UIView()
        header.backgroundColor = UIColor.blue30
        header.layer.cornerRadius = 4
        header.translatesAutoresizingMaskIntoConstraints = false

        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = .pureWhite
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.widthAnchor.constraint(equalToConstant: 18).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 19).isActive = true

        let titleLabel = StandardLabel(
            labelText: title,
            labelFont: .sfPro,
            labelType: .body,
            labelColor: .pureWhite,
            labelWeight: .semibold
        )

        let titleStack = UIStackView(arrangedSubviews: [iconView, titleLabel])
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

    // MARK: - Filled Button
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
//
//#Preview {
//    UINavigationController(rootViewController: MedicalRecordViewController())
//}
