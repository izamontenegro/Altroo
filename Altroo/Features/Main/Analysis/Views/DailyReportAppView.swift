//
//  DailyReportAppView.swift
//  Altroo
//
//  Created by Raissa Parente on 04/11/25.
//

import SwiftUI

struct DailyReportAppView: View {
    let viewModel: DailyReportViewModel
    
    var body: some View {
        ScrollView {
            VStack (spacing: 16) {
                HStack {
                    StandardLabelRepresentable(
                        labelFont: .sfPro,
                        labelType: .title2,
                        labelWeight: .semibold,
                        text: "Relatório Diário",
                        color: UIColor.black10
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    
                    Button {
                        
                    } label: {
                        Text("Exportar")
                    }
                }
                
                ForEach(viewModel.nonEmptyCategories, id: \.name) { category in
                    CategoryReportCard(categoryName: category.name, categoryIconName: category.icon, reports: category.reports)
                }
            }
        }
        .background(.blue80)
    }
}

//#Preview {
//    DailyReportAppView()
//}
