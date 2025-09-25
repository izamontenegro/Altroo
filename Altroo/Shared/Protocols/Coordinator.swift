//
//  Coordinator.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    func start()
}

extension Coordinator {
    func add(child: Coordinator) {
        childCoordinators.append(child)
    }
    func remove(child: Coordinator) {
        childCoordinators.removeAll { $0 === child }
    }
}
