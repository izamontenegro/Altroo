//
//  DailyReportAppView.swift
//  Altroo
//
//  Created by Raissa Parente on 04/11/25.
//

import SwiftUI

struct DailyReportAppView: View {
    @ObservedObject var viewModel: DailyReportViewModel
    
    @State private var pdfURL: URL?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            //SUBHEADER
            HStack(alignment: .bottom) {
                ReportTimeSection(text: "Data", date: $viewModel.startDate, type: .date)
                Spacer()
                ReportTimeSection(text: "Hora Inicial", date: $viewModel.startTime, type: .time)
                Image(systemName: "arrow.right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14)
                    .padding(.bottom, 10)
                ReportTimeSection(text: "Hora Final", date: $viewModel.endTime, type: .time)
            }
            .padding(Layout.standardSpacing)
            .background(.blue70)
            .clipShape(
                UnevenRoundedRectangle(bottomLeadingRadius: 20, bottomTrailingRadius: 20)
            )
            .onChange(of: viewModel.startDate) { _ in viewModel.feedArrays() }
            .onChange(of: viewModel.startTime) { _ in viewModel.feedArrays() }
            .onChange(of: viewModel.endTime) { _ in viewModel.feedArrays() }
            
            ScrollView {
                //TITLE
                HStack {
                    Text("Relatório Diário")
                        .font(.title2)
                        .foregroundStyle(.black10)
                        .fontDesign(.rounded)
                        .fontWeight(.semibold)
                    .padding(.top, 8)
                    
                    Spacer()
                    
                    VStack {
                        if let pdfURL {
                            ShareLink(item: pdfURL) {
                                Label("Compartilhar PDF", systemImage: "square.and.arrow.up")
                            }
                        } else {
                            Button("Gerar PDF") {
                                Task { @MainActor in
                                    let pdfCreator = PDFCreator()
                                    pdfURL = pdfCreator.createPDF(
                                        from: DailyReportPDFView(viewModel: viewModel)
                                    )
                                }
                            }
                        }
                    }
                }
                
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
//                        .padding(Layout.verySmallSpacing)
                        .frame(minWidth: 120, minHeight: 100, alignment: .top)
                        .fontDesign(.rounded)
                        .foregroundStyle(.black10)
                        .background(.pureWhite)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        ReportSectionTitle(text: "Registros por cuidador")
                        
                        VStack {
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
                    ReportSectionTitle(text: "Histórico de Registros")
                    ForEach(viewModel.nonEmptyCategories, id: \.name) { category in
                        CategoryReportCard(categoryName: category.name, categoryIconName: category.icon, reports: category.reports)
                    }
                }
            }
            .padding(.horizontal)
        }
        .background(.blue80)
    }
}

//#Preview {
//    DailyReportAppView()
//}
