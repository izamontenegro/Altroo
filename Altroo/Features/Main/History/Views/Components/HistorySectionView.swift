//
//  HistorySectionView.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 24/10/25.
//

import SwiftUI
import UIKit

struct HistorySectionView: View {
    @Binding var section: HistoryDaySection
    let onOpen: (ReportItem) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HistorySectionHeader(day: section.day, isExpanded: $section.isExpanded)

            if section.isExpanded {
                VStack(spacing: 0) {
                    ForEach(section.items.indices, id: \.self) { idx in
                        HistoryRowView(
                            item: section.items[idx],
                            isLast: idx == section.items.count - 1,
                            onTap: { onOpen(section.items[idx]) }
                        )
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(Color.pureWhite)
                )
            }
        }
        .padding(.horizontal, 16)
        .transaction { $0.animation = nil }
    }
}
