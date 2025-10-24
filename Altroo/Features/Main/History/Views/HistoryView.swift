//
//  TaskItem.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 23/10/25.
//

import SwiftUI

// MARK: - Helpers de formatação
private extension DateFormatter {
    static let historyHeader: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "pt_BR")
        df.setLocalizedDateFormatFromTemplate("dd/MM/yy EEEE") // ex: 12/09/25 sexta-feira
        return df
    }()
    
    static let historyTime: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "pt_BR")
        df.dateFormat = "HH:mm"
        return df
    }()
}

private extension Date {
    var historyHeaderText: String {
        let full = DateFormatter.historyHeader.string(from: self)
        // transformar "sexta-feira" em "Sexta"
        // pega só a parte do dia da semana e capitaliza 1ª letra
        if let dashIdx = full.firstIndex(of: " ") {
            let day = full[dashIdx...].trimmingCharacters(in: .whitespaces)
            let comps = full.split(separator: " ")
            // "12/09/25 sexta-feira" -> "12/09/25 - Sexta"
            let datePart = comps.first.map(String.init) ?? full
            let weekday = comps.dropFirst().joined(separator: " ")
                .replacingOccurrences(of: "-feira", with: "")
                .capitalized
            return "\(datePart) - \(weekday)"
        }
        return full.capitalized
    }
}

// MARK: - Header recolhível
struct HistorySectionHeader: View {
    let title: String
    @Binding var isExpanded: Bool
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                isExpanded.toggle()
            }
        } label: {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.white)
                Spacer()
                Image(systemName: "chevron.down")
                    .rotationEffect(.degrees(isExpanded ? 0 : -90))
                    .foregroundStyle(.white)
                    .font(.headline)
                    .padding(.trailing, 4)
            }
            .padding(.horizontal, 16)
            .frame(height: 44)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(.systemTeal))
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Linha estilo “card”
struct HistoryRowView: View {
    let item: HistoryItem
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: 12) {
                // Conteúdo à esquerda
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.title ?? "Sem título")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color(.systemTeal))
                    
                    Text(item.author ?? "Maria Clara") // ajuste para seu campo real
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                // Hora à direita
                if let date = item.date {
                    Text(DateFormatter.historyTime.string(from: date))
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(Color(.systemTeal))
                        .padding(.top, 2)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - View principal
struct HistoryView: View {
    @ObservedObject var viewModel: HistoryViewModel
    var onOpenSheet: () -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16, pinnedViews: []) {
                
                ForEach($viewModel.sections) { $section in
                    VStack(spacing: 10) {
                        // Header
                        HistorySectionHeader(
                            title: section.day.historyHeaderText,
                            isExpanded: $section.isExpanded
                        )
                        .padding(.horizontal, 16)
                        
                        // Itens
                        if section.isExpanded {
                            VStack(spacing: 0) {
                                ForEach(section.items.indices, id: \.self) { idx in
                                    let item = section.items[idx]
                                    
                                    HistoryRowView(item: item) {
                                        viewModel.selectedItem = item
                                        onOpenSheet()
                                    }
                                    .padding(.horizontal, 16)
                                    
                                    if idx < section.items.count - 1 {
                                        // Divider fino entre cards como no mock
                                        Rectangle()
                                            .fill(Color(.separator))
                                            .frame(height: 1 / UIScreen.main.scale)
                                            .padding(.horizontal, 24)
                                    }
                                }
                            }
                            .transition(.opacity.combined(with: .move(edge: .top)))
                            .padding(.bottom, 6)
                        }
                    }
                }
                
                // espaçamento final
                Spacer(minLength: 12)
            }
            .padding(.top, 12)
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
        }
        .onAppear { viewModel.reloadHistory() }
        .navigationTitle("Histórico")
        .navigationBarTitleDisplayMode(.inline)
    }
}
