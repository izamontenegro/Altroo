//
//  MyProfileViewController.swift
//  Altroo
//
//  Created by Marcelle Ribeiro Queiroz on 29/10/25.
//

import UIKit
import Combine

class MyProfileViewController: GradientNavBarViewController {
    
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: MyProfileViewModel
    
    init(viewModel: MyProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .pureWhite
        
        setupLayout()
        bindViewModel()
    }
    
    private let titleLabel: StandardLabel = {
        let label = StandardLabel(
            labelText: "Meu Perfil",
            labelFont: .sfPro,
            labelType: .title2,
            labelColor: .black10,
            labelWeight: .semibold
        )
        return label
    }()
    private let subtitleLabel: StandardLabel = {
        let label = StandardLabel(
            labelText: "Gerencie suas informações pessoais",
            labelFont: .sfPro,
            labelType: .body,
            labelColor: .black30,
            labelWeight: .regular
        )
        label.numberOfLines = 0
        return label
    }()
    private let editButton: CapsuleWithCircleView = {
        let label = CapsuleWithCircleView(
            capsuleColor: .teal20, text: "edit".localized,
            textColor: .pureWhite,
            nameIcon: "pencil",
            nameIconColor: .teal20,
            circleIconColor: .pureWhite
        )
        return label
    }()
    
    lazy var vStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 8
                
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(editButton)
        view.addSubview(vStack)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            editButton.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            
            vStack.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24),
            vStack.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
    }
    
    private func updateView() {

        let currentName = viewModel.caregiverName

        let name = InfoRowView(
            title: "Nome",
            info: currentName
        )

        vStack.addArrangedSubview(name)
    }
    
    private func bindViewModel() {
        viewModel.$caregiverName
            .receive(on: RunLoop.main)
            .sink { [weak self] newName in
                self?.updateView()
            }
            .store(in: &cancellables)
    }
}

//#Preview {
//    MyProfileViewController(viewModel: MyProfileViewModel())
//}
