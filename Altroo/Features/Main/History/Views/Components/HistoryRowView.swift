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
                    HStack(spacing: 8) {
                        // MARK: Icon Type
                        ZStack {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.blue80)
                                .frame(width: 24, height: 24)
                            Image(systemName: item.type.iconName)
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.blue20)
                                .frame(width: 15, height: 15)
                        }
                        // MARK: History Type Name
                        Text(item.type.displayText)
                            .fontWeight(.semibold)
                            .font(.callout)
                            .foregroundStyle(.blue20)
                        // MARK: Chevron
                        Image(systemName: "chevron.right")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.blue20)
                            .frame(width: 12, height: 12)
                            .font(Font.system(size: 14, weight: .regular))
                    }
                    
                    Spacer()
                    
                    HStack {
                        // MARK: Icon with the initials of the user who made it
                        Text(item.base.reportAuthor?.getInitials() ?? "—")
                            .font(.caption2)
                            .foregroundStyle(.pureWhite)
                            .padding(6)
                            .background {
                                Circle()
                                    .fill(.blue20)
                            }
                        // MARK: Time the user marked that they did
                        if let date = item.base.reportTime {
                            Text(DateFormatterHelper.hourFormatter(date: date))
                                .font(.subheadline)
                                .foregroundStyle(.blue20)
                                .padding(.vertical, 2)
                                .padding(.horizontal, 4)
                                .background {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(.blue80)
                                }
                                .frame(width: 50)
                        }
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, 8)
            .padding(.bottom, 12)
            .background {
                UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 8, bottomTrailingRadius: 8, topTrailingRadius: 0)
                    .fill(.pureWhite)
            }
            .overlay(alignment: .bottom) {
                if !isLast {
                    Rectangle()
                        .fill(.blue70)
                        .frame(height: 0.5)
                }
            }
        }
        .buttonStyle(.plain)
    }
}
