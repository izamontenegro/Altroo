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
    let item: HistoryItem
    
    var titleText: String { item.title ?? "Sem título" }
    var authorText: String { item.author ?? "—" }
    var dateText: String {
        if let d = item.date { return DateFormatterHelper.longDayString(from: d) }
        return "—"
    }
    var timeText: String {
        if let d = item.date { return DateFormatterHelper.timeHMString(from: d) }
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
                   
                    InfoRowPill(left: "Concluída", right: dateText, rightEmphasis: true)
                    InfoRowPill(left: "Horário", right: timeText, rightEmphasis: true)
                    InfoRowPill(left: "Concluída por", right: authorText, rightEmphasis: true)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
            .navigationTitle(item.activityType ?? "Histórico")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Fechar") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Excluir", role: .destructive) {
                        viewModel.deleteHistory(item)
                        dismiss()
                    }
                }
            }
            .background(Color(.white).ignoresSafeArea())
        }
    }
}
