//
//  DailyReportAppView.swift
//  Altroo
//
//  Created by Raissa Parente on 04/11/25.
//

import SwiftUI

struct DailyReportAppView: View {
    var body: some View {
        VStack {
            HStack {
                StandardLabelRepresentable(
                    labelFont: .sfPro,
                    labelType: .title2,
                    labelWeight: .semibold,
                    text: "Histórico",
                    color: UIColor.black10
                )
                .padding(.horizontal, 16)
                .padding(.top, 8)
                
                Button {
                    
                } label: {
                    Text("Exportar")
                }
            }
            
            
        }
    }
}

#Preview {
    DailyReportAppView()
}
