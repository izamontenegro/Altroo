//
//  HistorySectionHeader.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 24/10/25.
//
import SwiftUI
import UIKit

struct HistorySectionHeader: View {
    let day: Date
    @Binding var isExpanded: Bool
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.55, dampingFraction: 0.9)) {
                isExpanded.toggle()
            }
        } label: {
            HStack(spacing: 8) {
                StandardLabelRepresentable(
                    labelFont: .sfPro,
                    labelType: .callOut,
                    labelWeight: .medium,
                    text: "\(DateFormatterHelper.historyDateNumber(from: day)) - \(DateFormatterHelper.historyWeekdayShort(from: day))",
                    color: UIColor.pureWhite
                )
                
                Spacer()
                
                Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.pureWhite)
            }
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity, minHeight: 44)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color.teal20)
            )
        }
        .buttonStyle(.plain)
    }
}
