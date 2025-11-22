//
//  InfoRowPill.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 24/10/25.
//

import SwiftUI

struct HistoryDetailSheet: View {
    
    @Environment(\.dismiss) var dismiss
    
    var viewModel: HistoryViewModel
    let item: ReportItem
    
    var titleText: String { item.type.displayText}
    var authorText: String { item.base.reportAuthor ?? "—" }
    var dateText: String {
        if let d = item.base.reportTime { return DateFormatterHelper.historyDateNumber(from: d) }
        return "—"
    }
    var timeText: String {
        if let d = item.base.reportTime { return DateFormatterHelper.timeHMString(from: d) }
        return "—"
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
//                    // MARK: - Header
//                    ZStack(alignment: .bottomLeading) {
//                        // TODO: ADICIONAR IMAGEM AQUI
//                        Color.blue20
//                            .ignoresSafeArea()
//                        
//                        Text(titleText)
//                            .font(.title2.weight(.semibold))
//                            .fontDesign(.rounded)
//                            .fixedSize(horizontal: false, vertical: true)
//                            .foregroundStyle(.blue80)
//                            .padding()
//                    }

                    VStack(alignment: .leading, spacing: 16) {
                        // MARK: - Information that all types have
                        VStack(alignment: .leading, spacing: 8) {
                            VStack(alignment: .leading, spacing: 3) {
                                Text("registered_by".localized)
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .fontDesign(.rounded)
                                    .foregroundStyle(.blue20)
                                Text(authorText)
                                    .font(.title3)
                                    .fontWeight(.regular)
                                    .fontDesign(.rounded)
                                    .foregroundStyle(.black10)
                            }
                            HStack(alignment: .top, spacing: 30) {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("time".localized)
                                        .font(.title3)
                                        .fontWeight(.medium)
                                        .fontDesign(.rounded)
                                        .foregroundStyle(.blue20)
                                    Text(timeText)
                                        .font(.title3)
                                        .fontWeight(.regular)
                                        .fontDesign(.rounded)
                                        .foregroundStyle(.black10)
                                }
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("date".localized)
                                        .font(.title3)
                                        .fontWeight(.medium)
                                        .fontDesign(.rounded)
                                        .foregroundStyle(.blue20)
                                    Text(dateText)
                                        .font(.title3)
                                        .fontWeight(.regular)
                                        .fontDesign(.rounded)
                                        .foregroundStyle(.black10)
                                }
                            }
                        }
                        
                        Rectangle()
                            .fill(.blue20)
                            .frame(width: .infinity, height: 1)
                        
                        //MARK: - Info especific to a certain type
                        if item.type == .feeding { configureItem(item) }
                        if item.type == .hydration { configureItem(item) }
                        if item.type == .stool { configureItem(item) }
                        if item.type == .urine { configureItem(item) }
                        if item.type == .symptom { configureItem(item) }
                        if item.type == .task { configureItem(item) }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.bottom, 24)
            }
            .navigationTitle(item.type.displayText)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // MARK: Close
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("close".localized)
                            .font(.body)
                            .foregroundStyle(.blue20)
                    }
                }
                // MARK: Delete
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // TODO: COLOCAR O ALERTA ANTES DE EXCLUIR
                        viewModel.deleteHistory(item)
                        dismiss()
                    } label: {
                        Text("exclude".localized)
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundStyle(.red20)
                    }
                }
            }
            .background(Color(.white).ignoresSafeArea())
        }
    }
    
    @ViewBuilder
    private func configureItem(_ item: ReportItem) -> some View {
        switch item {
        case .stool(let stoolRecord):
            StoolInfoEspecificView(type: stoolRecord.formatType, stoolColoration: stoolRecord.colorType, observation: stoolRecord.notes)
            
        case .urine(let urineRecord):
            UrineInfoEspecificView(urineColoration: urineRecord.colorType, observation: urineRecord.urineObservation)
            
        case .feeding(let feedingRecord):
            FeedingInfoEspecific(category: feedingRecord.mealCategory, reception: feedingRecord.amountEaten, observation: feedingRecord.notes)
            
        case .hydration(let hydrationRecord):
            HydrationInfoEspecificView(added: hydrationRecord.reportTitle)
            
        case .task(let taskInstance):
            TaskInfoEspecificView(title: taskInstance.reportTitle, observation: taskInstance.reportNotes)
            
        case .symptom(let symptom):
            SymptomInfoEspecificView(title: symptom.name, observation: symptom.symptomDescription)
        }
    }
}
