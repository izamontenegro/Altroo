//
//  HistoryRowView.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 24/10/25.
//

import SwiftUI
import UIKit

struct HistoryRowView: View {
    let item: ReportItem
    let isLast: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    StandardLabelRepresentable(
                        labelFont: .sfPro,
                        labelType: .callOut,
                        labelWeight: .semibold,
                        text: item.base.reportTitle,
                        color: UIColor.teal10
                    )
                    
                    Spacer()
                    
                    if let date = item.base.reportTime {
                        StandardLabelRepresentable(
                            labelFont: .sfPro,
                            labelType: .callOut,
                            labelWeight: .regular,
                            text: DateFormatterHelper.hourFormatter(date: date),
                            color: UIColor.teal10
                        )
                        .frame(width: 50)
                    }
                }
                
                StandardLabelRepresentable(
                    labelFont: .sfPro,
                    labelType: .callOut,
                    labelWeight: .regular,
                    text: item.base.reportAuthor ?? "—",
                    color: UIColor.black10
                )
            }
            .padding(.horizontal, 12)
            .padding(.top, 8)
            .padding(.bottom, 12)
            .background(Color.pureWhite)
            .overlay(alignment: .bottom) {
                if !isLast {
                    Rectangle()
                        .fill(.white50)
                        .frame(height: 1)
                        .padding(.horizontal, 12)
                }
            }
            .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }
}
