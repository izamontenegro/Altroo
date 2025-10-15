//
//  AppTabBarController.swift
//  Altroo
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 22/09/25.
//

import UIKit

final class AppTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
//        tabBar.isHidden = true
    }
    
    private func setupAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        
        // Ícones e textos
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(named: "blue30")
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(named: "blue30") ?? .systemBlue,
            .font: UIFont.systemFont(ofSize: 12, weight: .bold)
        ]
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(named: "pureWhite")
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(named: "pureWhite") ?? .white,
            .font: UIFont.systemFont(ofSize: 12, weight: .regular)
        ]
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.backgroundColor = .clear
    }
}

import SwiftUI

enum Tab: String, CaseIterable {
    case today, history, report, settings
    
    var tabIcon: String {
        switch self {
        case .today: "heart.text.square.fill"
        case .history: "folder.fill"
        case .report: "chart.bar.xaxis.ascending.badge.clock"
        case .settings: "gearshape.fill"
        }
    }
    
    var tabName: String {
        switch self {
        case .today: "Hoje"
        case .history: "Histórico"
        case .report: "Relatório"
        case .settings: "Ajustes"
        }
    }
}

struct CustomTabBar: View {
    
    @Binding var currentTab: Tab
    
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
                            currentTab = tab
                        }
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: tab.tabIcon)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity, maxHeight: 24)
                            
                            Text(tab.tabName)
                                .font(Font.custom("Comfortaa", size: 14))
//                                .fontWeight(currentTab == tab ? .bold : .regular)
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(currentTab == tab ? .blue30 : .pureWhite)
                        .offset(y: currentTab == tab ? -15 : 0)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .background(alignment: .leading) {
                UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 10, style: .continuous)
                    .fill(LinearGradient(colors: selectedBackgroundColor,
                                         startPoint: .top, endPoint: .bottom))
                    .frame(width: buttonWidth, height: 120, alignment: .bottom)
                    .shadow(color: .blue40.opacity(0.1), radius: 15, x: 2, y: 4)
                    .offset(x: indicatorOffset(width: width), y: 0)
            }
        }
        .frame(height: 85)
        .padding(.top, 17)
        .padding(.horizontal, 16)
        .background() {
            UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 10, style: .continuous)
                .fill(LinearGradient(colors: backgroundColor,
                                     startPoint: .top, endPoint: .bottom))
                .shadow(color: .blue70, radius: 15, x: 0, y: -4)
        }
    }
    
    func indicatorOffset(width: CGFloat) -> CGFloat {
        let index = CGFloat(getIndex())
        if index == 0 { return 0 }
        
        let buttonWidth = width / CGFloat(Tab.allCases.count)
        
        return index * buttonWidth
    }
    
    func getIndex() -> Int {
        switch currentTab {
        case .today:
            return 0
        case .history:
            return 1
        case .report:
            return 2
        case .settings:
            return 3
        }
    }
}

struct ContentView: View {
    
    @State var currentTab: Tab = .today
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                TabView(selection: $currentTab) {
                    ZStack {
                        Color(.red)
                            .ignoresSafeArea()
                        Text("hoje")
                    }
                    .tag(Tab.today)
                    
                    Text("histórico")
                        .tag(Tab.history)
                    
                    Text("análise")
                        .tag(Tab.report)
                    
                    Text("ajustes")
                        .tag(Tab.settings)
                }
                
                CustomTabBar(currentTab: $currentTab)
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    ContentView()
}
