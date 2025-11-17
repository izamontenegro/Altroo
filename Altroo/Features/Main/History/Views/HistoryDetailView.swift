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
                    Text(titleText)
                        .font(.title2.weight(.semibold))
                        .fontDesign(.rounded)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 12)
                        .foregroundStyle(.primary)
                   
                    InfoRowPill(left: "Concluída por", right: authorText, rightEmphasis: true)
                    HStack {
                        InfoRowPill(left: "Horário", right: timeText, rightEmphasis: true)
                        InfoRowPill(left: "Data", right: dateText, rightEmphasis: true)
                    }
                    
                    Divider()
                    
                    //TODO: INFO ESPECIFIC TO A CERTAIN CATEGORY

                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
            .navigationTitle(item.type.displayText)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Fechar") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Excluir", role: .destructive) {
                        //TODO
                        viewModel.deleteHistory(item)
                        dismiss()
                    }
                }
            }
            .background(Color(.white).ignoresSafeArea())
        }
    }
}
