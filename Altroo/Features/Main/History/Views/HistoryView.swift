//
//  TaskItem.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 23/10/25.
//
import SwiftUI
import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: HistoryViewModel
    var onOpenSheet: () -> Void

    var body: some View {
        List {
            ForEach(viewModel.sections) { section in
                Section(header: Text(section.day, style: .date)) {
                    ForEach(section.items, id: \.objectID) { item in
                        Button {
                          
                            viewModel.selectedItem = item
                            onOpenSheet()
                        } label: {
                            VStack(alignment: .leading) {
                                Text(item.title ?? "Sem título")
                                if let date = item.date {
                                    Text(date, style: .time)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.reloadHistory()
        }
    }
}
