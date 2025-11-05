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
        ScrollView
        {
            VStack {
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
                
                CategoryReportCard(categoryName: "Fezes", categoryIconName: "toilet.fill", reports: viewModel.stoolRecords)
                CategoryReportCard(categoryName: "Urina", categoryIconName: "drop.halffull", reports: viewModel.urineRecords)
                CategoryReportCard(categoryName: "Alimentação", categoryIconName: "takeoutbag.and.cup.and.straw.fill", reports: viewModel.feedingRecords)
                CategoryReportCard(categoryName: "Hidratação", categoryIconName: "waterbottle.fill", reports: viewModel.hydrationRecords)
                CategoryReportCard(categoryName: "Intercorrência", categoryIconName: "exclamationmark.triangle.fill", reports: viewModel.symptomRecords)
                CategoryReportCard(categoryName: "Tarefas", categoryIconName: "newspaper", reports: viewModel.tasksRecords)
            }
        }
    }
}

//#Preview {
//    DailyReportAppView()
//}
