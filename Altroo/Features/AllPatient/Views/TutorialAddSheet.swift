//
//  TutorialAddSheet.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 30/09/25.
//

import UIKit

class TutorialAddSheet: UIViewController {

    private lazy var closeButton: UIBarButtonItem = {
        return UIBarButtonItem(
            title: "Fechar",
            style: .plain,
            target: self,
            action: #selector(didTapClose)
        )
    }()
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Layout.mediumSpacing
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .pureWhite
        setupNavigationBar()
        setupContent()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = ""
        navigationItem.leftBarButtonItem = closeButton
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    private func makeIconView(text: String) -> PulseIcon {
        let iconView = PulseIcon(text: text, color: UIColor(resource: .teal30), iconColor: .pureWhite, shadowColor: UIColor(resource: .teal60))
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 50),
            iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor)
        ])
        
        return iconView
    }
    
    private func setupContent() {
        let mainTitle = StandardLabel(
            labelText: "Tutorial",
            labelFont: .sfPro,
            labelType: .title2,
            labelColor: .black10,
            labelWeight: .semibold
        )
        mainTitle.numberOfLines = 0
        
        let subTitle = StandardLabel(
            labelText: "Siga o passo-a-passo a seguir para acessar um perfil já cadastrado na plataforma. ",
            labelFont: .sfPro,
            labelType: .body,
            labelColor: .black30,
            labelWeight: .regular
        )
        subTitle.numberOfLines = 0
        
        stackView.addArrangedSubview(mainTitle)
        stackView.setCustomSpacing(0, after: mainTitle)
        stackView.addArrangedSubview(subTitle)
        
        let line1 = makeLine(title: "Acesse o perfil do assistido", description: "No dispositivo em que o assistido está cadastrado, abra o aplicativo na página hoje e acesse o perfil de quem deseja cuidar.", iconText: "1")
        let line2 = makeLine(title: "Clique em Convidar Cuidador", description: "Aperte o botão indicado e envie o link de convite da forma que preferir para a pessoa que deseja adicionar como cuidador.", iconText: "2")
        let line3 = makeLine(title: "Confirme em ”Abrir”", description: "Cheque os seus dados e do paciente e aceite o convite para entrar no perfil.", iconText: "3")
        
        stackView.addArrangedSubview(line1)
        stackView.addArrangedSubview(line2)
        stackView.addArrangedSubview(line3)
        
        view.addSubview(stackView)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Layout.largeSpacing),
            stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Layout.mediumSpacing),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: safeArea.trailingAnchor, constant: -Layout.mediumSpacing)
        ])
    }
    
    private func makeLine(title: String, description: String, iconText: String) -> UIStackView {
            let titleLabel = StandardLabel(
                labelText: title,
                labelFont: .sfPro,
                labelType: .title3,
                labelColor: .teal10,
                labelWeight: .medium
            )
            titleLabel.numberOfLines = 0

            let descriptionLabel = StandardLabel(
                labelText: description,
                labelFont: .sfPro,
                labelType: .body,
                labelColor: .black10,
                labelWeight: .regular
            )
            descriptionLabel.numberOfLines = 0

            let textStack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
            textStack.axis = .vertical
            textStack.spacing = 0
            textStack.alignment = .leading
            textStack.setContentHuggingPriority(.defaultLow, for: .horizontal)

            let iconView = makeIconView(text: iconText)
            iconView.setContentHuggingPriority(.required, for: .horizontal)

            let lineStack = UIStackView(arrangedSubviews: [iconView, textStack])
            lineStack.axis = .horizontal
            lineStack.spacing = 16
            lineStack.alignment = .center
            lineStack.translatesAutoresizingMaskIntoConstraints = false
            lineStack.distribution = .fill

            return lineStack
        }

}

//#Preview {
//    UINavigationController(rootViewController: TutorialAddSheet())
//}
