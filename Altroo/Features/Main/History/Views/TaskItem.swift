//
//  TaskItem.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 23/10/25.
//


import SwiftUI

// MARK: - Models

struct TaskItem: Identifiable {
    let id = UUID()
    let title: String
    let author: String
    let date: Date       // data e hora do item
}

struct DaySection: Identifiable {
    let id = UUID()
    let day: Date        // meia-noite do dia
    var items: [TaskItem]
    var isExpanded: Bool = true
}

// MARK: - View

struct HistoryView: View {
    // Demo: dados de exemplo
    @State private var sections: [DaySection] = HistoryView.sampleSections()
    
    var onOpenDetail: (() -> Void)? = nil

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Histórico")
                        .font(.largeTitle).bold()
                        .padding(.top, 8)
                        .padding(.horizontal, 16)

                    ForEach($sections) { $section in
                        DayCard(section: $section)
                            .padding(.horizontal, 16)
                    }
                }
                .padding(.bottom, 24)
            }
        }
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Components

private struct DayCard: View {
    @Binding var section: DaySection

    var body: some View {
        VStack(spacing: 0) {
            Button {
                withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                    section.isExpanded.toggle()
                }
            } label: {
                HStack {
                    Text(DateFormatter.ptDayHeader.string(from: section.day))
                        .foregroundColor(.white)
                        .font(.headline)
                        .bold()
                    Spacer()
                    Image(systemName: section.isExpanded ? "chevron.down" : "chevron.right")
                        .foregroundColor(.white)
                        .font(.system(size: 17, weight: .semibold))
                }
                .padding(.horizontal, 16)
                .frame(height: 52)
                .background(AppColors.teal)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            }

            if section.isExpanded {
                VStack(spacing: 0) {
                    ForEach(section.items) { item in
                        TaskRow(item: item)
                        if item.id != section.items.last?.id {
                            Divider()
                                .padding(.leading, 16)
                        }
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(.white)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(AppColors.cardBorder, lineWidth: 0.5)
                )
                .shadow(color: AppColors.cardShadow, radius: 8, x: 0, y: 2)
                .padding(.top, 8)
            }
        }
    }
}

private struct TaskRow: View {
    let item: TaskItem

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                Text(item.title)
                    .font(.headline)
                    .foregroundColor(AppColors.teal)
                Text(item.author)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Text(DateFormatter.ptHour.string(from: item.date))
                .font(.headline)
                .foregroundColor(AppColors.teal)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}

// MARK: - Helpers

enum AppColors {
    // verde água da imagem
    static let teal       = Color(red: 70/255, green: 169/255, blue: 158/255)
    static let background = Color(red: 235/255, green: 242/255, blue: 248/255)
    static let cardBorder = Color.black.opacity(0.08)
    static let cardShadow = Color.black.opacity(0.08)
}

extension DateFormatter {
    static let ptDayHeader: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "pt_BR")
        df.dateFormat = "dd/MM/yy – EEEE" // ex: 12/09/25 – sexta
        df.doesRelativeDateFormatting = false
        return df
    }()

    static let ptHour: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "pt_BR")
        df.dateFormat = "HH:mm"
        return df
    }()
}

extension HistoryView {
    /// Gera seções agrupando um vetor de itens por dia (00:00)
    static func buildSections(from items: [TaskItem]) -> [DaySection] {
        let grouped = Dictionary(grouping: items) { item -> Date in
            let cal = Calendar.current
            let comps = cal.dateComponents([.year, .month, .day], from: item.date)
            return cal.date(from: comps)! // meia-noite
        }

        return grouped
            .map { DaySection(day: $0.key, items: $0.value.sorted(by: { $0.date > $1.date })) }
            .sorted(by: { $0.day > $1.day })
    }

    /// Dados fake só para visualizar
    static func sampleSections() -> [DaySection] {
        let cal = Calendar.current
        let now = Date()

        func at(_ dayDelta: Int, _ hour: Int, _ minute: Int = 0) -> Date {
            cal.date(bySettingHour: hour, minute: minute, second: 0,
                     of: cal.date(byAdding: .day, value: dayDelta, to: now)!)!
        }

        let items: [TaskItem] = [
            .init(title: "Tarefa Concluída",     author: "Maria Clara", date: at(-1, 14, 00)),
            .init(title: "Fezes Registradas",    author: "Maria Clara", date: at(-1, 14, 00)), // mesmo horário só p/ exemplo
            .init(title: "Nome da atividade",    author: "Maria Clara", date: at(-1, 14, 00)),
            .init(title: "Nome da atividade",    author: "Maria Clara", date: at(-1, 14, 00)),

            .init(title: "Relatório enviado",    author: "João Pedro",  date: at(-3, 9, 30)),
            .init(title: "Peso registrado",      author: "João Pedro",  date: at(-3, 11, 15))
        ]

        var sections = buildSections(from: items)

        // de propósito: deixa o dia mais antigo fechado (como “Quarta - 10/09” no mock)
        if sections.indices.contains(1) {
            sections[1].isExpanded = false
        }
        return sections
    }
}

// MARK: - Preview

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HistoryView()
        }
    }
}
