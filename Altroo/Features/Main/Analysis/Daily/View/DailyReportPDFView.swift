//
//  DailyReportPDFView.swift
//  Altroo
//
//  Created by Raissa Parente on 07/11/25.
//
import SwiftUI

struct DailyReportPDFView: View {
    @ObservedObject var viewModel: DailyReportViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            //HEADER
            ExportableReportHeader(title: "Relatório Diário", registerStartDate: viewModel.startDate, registerStartTime: viewModel.startTime, registerEndTime: viewModel.endTime, exportDate: .now)
            
            //COUNT
            ReportCountView(viewModel: viewModel)
            
            //CATEGORIES
            VStack(alignment: .leading, spacing: 12) {
                ForEach(viewModel.nonEmptyCategories, id: \.name) { category in
                    CategoryReportSection(categoryName: category.name, categoryIconName: category.icon, reports: category.reports)
                }
            }
        }
        .padding(24)
        .frame(maxWidth: 530, alignment: .leading)
        .background(Color.white)
    }
}

