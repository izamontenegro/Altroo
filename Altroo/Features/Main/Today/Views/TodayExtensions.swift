//
//  TodayExtensions.swift
//  Altroo
//
//  Created by Layza Maria Rodrigues Carneiro on 09/11/25.
//

extension TodayViewController: SymptomsCardDelegate {
    func tappedSymptom(_ symptom: Symptom, on card: SymptomsCard) {
        delegate?.goToSymptomDetail(with: symptom)
    }
}

extension TodayViewController: TaskCardDelegate {
    func taskCardDidSelect(_ task: TaskInstance) {
        onTaskSelected?(task)
    }
    
    func taskCardDidMarkAsDone(_ task: TaskInstance) {
        viewModel.markAsDone(task)
    }
}

extension TodayViewController: TaskHeaderDelegate {
    func didTapAddTask() {
        delegate?.goTo(.addNewTask)
    }
    
    func didTapSeeTask() {
        delegate?.goTo(.seeAllTasks)
    }
}

extension TodayViewController: IntercurrenceHeaderDelegate {
    func didTapAddIntercurrence() {
        delegate?.goTo(.addSymptom)
    }
}

extension TodayViewController: ProfileToolbarDelegate {
    func didTapProfileView() {
        delegate?.goTo(.careRecipientProfile)
    }
    
    func didTapEditCapsuleView() {
        delegate?.goTo(.editSection)
    }
}
