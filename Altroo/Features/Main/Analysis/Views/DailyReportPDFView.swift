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
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    ReportSectionTitle(text: "Contagem")
                    
                    VStack(alignment: .leading) {
                        Text("\(viewModel.combinedRecords.count)")
                            .font(.largeTitle)
                        Text("Registros")
                            .font(.callout)
                            .fixedSize(horizontal: true, vertical: false)
                    }
                    .padding(Layout.standardSpacing)
                    .frame(minWidth: 150, minHeight: 100, alignment: .top)
                    .fontDesign(.rounded)
                    .foregroundStyle(.black10)
                    .background(.pureWhite)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                VStack(alignment: .leading) {
                    ReportSectionTitle(text: "Registros por cuidador")
                    
                    VStack(alignment: .leading) {
                        ForEach(viewModel.reportsByAuthor.keys.sorted(), id: \.self) { author in
                            ReportCaretakerCount(name: author, count: viewModel.reportsByAuthor[author] ?? 0)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(Layout.standardSpacing)
                    .frame(maxWidth: .infinity, minHeight: 100, alignment: .top)
                    .fontDesign(.rounded)
                    .foregroundStyle(.black10)
                    .background(.pureWhite)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .layoutPriority(1)
            }
            
            //CHART
//                SectionTitle("Registros por Hora")
            
            //CATEGORIES
            VStack(alignment: .leading, spacing: 12) {
                ForEach(viewModel.nonEmptyCategories, id: \.name) { category in
                    CategoryReportSection(categoryName: category.name, categoryIconName: category.icon, reports: category.reports)
                }
            }
        }
        .padding(24)
        .frame(maxWidth: 500, alignment: .leading)
        .background(Color.white)
    }
}

