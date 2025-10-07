//
//  AllTasksViewController.swift
//  Altroo
//
//  Created by Raissa Parente on 02/10/25.
//

import UIKit
import Combine


class AllTasksViewController: UIViewController {
    private let viewModel: AllTasksViewModel
    private var cancellables = Set<AnyCancellable>()
    
    let titleLabel = StandardLabel(labelText: "Shifts", labelFont: .sfPro, labelType: .h2, labelColor: .black, labelWeight: .semibold)

    let descriptionLabel = StandardLabel(labelText: "Confira os tarefas cadastradas no sistema ou adicione uma nova tarefa para visualizá-la aqui.", labelFont: .sfPro, labelType: .h3, labelColor: .black, labelWeight: .semibold)
    
    init(viewModel: AllTasksViewModel) {
            self.viewModel = viewModel
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
//        view.addSubview(viewLabel)
//        
//        NSLayoutConstraint.activate([
//            viewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            viewLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
    }
}
