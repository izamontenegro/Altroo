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
    let onOpen: (HistoryItem) -> Void
    
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
                .transition(
                    .asymmetric(
                        insertion: .opacity.combined(with: .move(edge: .top))
                            .animation(.easeOut(duration: 0.18)),
                        removal: .opacity.animation(.easeIn(duration: 0.12))
                    )
                )
            }
        }
        .padding(.horizontal, 16)
    }
}
