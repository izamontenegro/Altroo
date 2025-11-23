//
//  HistorySectionHeader.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 24/10/25.
//

import SwiftUI
import UIKit

struct HistorySectionHeader: View {
    
    @Binding var isExpanded: Bool
    
    let day: Date
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.55, dampingFraction: 0.9)) {
                isExpanded.toggle()
            }
        } label: {
            HStack {
                Text("\(DateFormatterHelper.historyDateNumber(from: day)) - \(DateFormatterHelper.historyWeekdayShort(from: day))")
                    .font(.callout)
                    .foregroundStyle(.pureWhite)
                
                Spacer()
                
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .font(.callout)
                    .foregroundColor(.pureWhite)
            }
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity, minHeight: 33)
            .background {
                UnevenRoundedRectangle(topLeadingRadius: 8,
                                       bottomLeadingRadius: isExpanded ? 0 : 8,
                                       bottomTrailingRadius: isExpanded ? 0 : 8,
                                       topTrailingRadius: 8)
                .fill(.teal20)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HistorySectionHeader(
        isExpanded: .constant(true),
        day: Date()
    )
    .padding()
}
