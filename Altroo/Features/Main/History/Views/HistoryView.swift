//
//  TaskItem.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 23/10/25.
//

import SwiftUI
import UIKit

struct HistoryView: View {
    @ObservedObject var viewModel: HistoryViewModel
    @State var showSheet: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                StandardLabelRepresentable(
                    labelFont: .sfPro,
                    labelType: .title2,
                    labelWeight: .semibold,
                    text: "Histórico",
                    color: UIColor.black10
                )
                .padding(.horizontal, 16)
                .padding(.top, 8)
                
                if(viewModel.sections.isEmpty) {
                    Text("Você ainda não adicionou nenhum registro ou atividade.")
                        .font(.headline)
                        .foregroundStyle(.black30)
                        .padding(.leading)
                } else {
                    LazyVStack(spacing: 8) {
                        ForEach($viewModel.sections) { $section in
                            HistorySectionView(section: $section) { item in
                                viewModel.selectedItem = item
                                showSheet = true
                            }
                        }
                        Spacer()
                    }
                }
            }
            .padding(.top, 8)
        }
        .background(Color.blue80.ignoresSafeArea())
        .onAppear { viewModel.reloadHistory() }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showSheet, content: {
            if let item = viewModel.selectedItem {
                HistoryDetailSheet(viewModel: viewModel, item: item)
                    .presentationDetents([.medium])
            } else {
                Text("erro ao selecionar item")
            }
        })
    }
}
