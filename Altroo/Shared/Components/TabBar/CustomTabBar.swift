//
//  Custom.swift
//  Altroo
//
//  Created by Marcelle Ribeiro Queiroz on 15/10/25.
//

import UIKit
import SwiftUI

enum Tab: String, CaseIterable {
    case /*patients, */report, today, history, settings
    
    var tabIcon: String {
        switch self {
//        case .patients: "person.fill"
        case .report: "chart.bar.xaxis.ascending.badge.clock"
        case .today: "heart.text.square.fill"
        case .history: "folder.fill"
        case .settings: "gearshape.fill"
        }
    }
    
    var tabName: String {
        switch self {
//        case .patients: "Assistidos"
        case .report: "Relatório"
        case .today: "Hoje"
        case .history: "Histórico"
        case .settings: "Ajustes"
        }
    }
}

struct CustomTabBar: View {
    
    @ObservedObject var model: TabModel
    
    var backgroundColor = [Color.blue20, Color.blue40]
    var selectedBackgroundColor = [Color.pureWhite, Color.blue60]
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let buttonWidth = width / CGFloat(Tab.allCases.count)
            
            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Button {
                        withAnimation(.easeInOut) {
                            model.currentTab = tab
                        }
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: tab.tabIcon)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity, maxHeight: 20)
                            
                            Text(tab.tabName)
                                .font(Font.custom("Comfortaa", size: 12))
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(model.currentTab == tab ?
                            .blue30 : .pureWhite)
                        .offset(y: model.currentTab == tab ? -15 : 0)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .background(alignment: .leading) {
                UnevenRoundedRectangle(topLeadingRadius: 10,
                                       bottomLeadingRadius: 0,
                                       bottomTrailingRadius: 0,
                                       topTrailingRadius: 10,
                                       style: .continuous)
                    .fill(LinearGradient(colors: selectedBackgroundColor,
                                         startPoint: .top, endPoint: .bottom))
                    .frame(width: buttonWidth, height: 90, alignment: .bottom)
                    .shadow(color: .blue40.opacity(0.1), radius: 15, x: 2, y: 4)
                    .offset(x: indicatorOffset(width: width), y: 0)
            }
        }
        .frame(height: 70)
        .padding(.top, 17)
        .background() {
            UnevenRoundedRectangle(topLeadingRadius: 10,
                                   bottomLeadingRadius: 0,
                                   bottomTrailingRadius: 0,
                                   topTrailingRadius: 10,
                                   style: .continuous)
                .fill(LinearGradient(colors: backgroundColor,
                                     startPoint: .top, endPoint: .bottom))
                .shadow(color: .blue70, radius: 15, x: 0, y: -4)
        }
        .ignoresSafeArea()
    }
    
    func indicatorOffset(width: CGFloat) -> CGFloat {
        let index = CGFloat(getIndex())
        if index == 0 { return 0 }
        
        let buttonWidth = width / CGFloat(Tab.allCases.count)
        
        return index * buttonWidth
    }
    
    func getIndex() -> Int {
        switch model.currentTab {
//        case .patients: return 0
        case .report: return 0
        case .today: return 1
        case .history: return 2
        case .settings: return 3
        }
    }
}

//#Preview("CustomTabBar") {
//    @Previewable @StateObject var model = TabModel()
//    CustomTabBar(model: model)
//}
