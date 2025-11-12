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
        ScrollView {
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
            
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading) {
                    //TITLE
                    HStack {
                        Text("Relatório Diário")
                            .font(.title2)
                            .foregroundStyle(.black10)
                            .fontDesign(.rounded)
                            .fontWeight(.semibold)
                            .padding(.top, 8)
                        
                        Spacer()
                        
                        if let pdfURL {
                            ShareLink(item: pdfURL) {
                                CircleCapsule(text: "Exportar", icon: "square.and.arrow.up")
                            }
                        } else {
                            CircleCapsule(text: "Exportar", icon: "square.and.arrow.up")
                        }
                        
                    }
                    
                    //COUNT
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            ReportSectionTitle(text: "Contagem")
                            
                            VStack(alignment: .leading) {
                                Text("\(viewModel.combinedRecords.count)")
                                    .font(.largeTitle)
                                    .padding(.horizontal, 12)
                                    .padding(.top, 10)

                                Text("Registros")
                                    .font(.callout)
                                    .fixedSize(horizontal: true, vertical: false)
                                    .padding(.horizontal, 12)
                            }
                            .frame(minWidth: 120, minHeight: 100, alignment: .topLeading)
                            .fontDesign(.rounded)
                            .foregroundStyle(.black10)
                            .background(.pureWhite)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            ReportSectionTitle(text: "Registros por cuidador")
                            
                            VStack {
                                if viewModel.reportsByAuthor.isEmpty {
                                    Text("Não há registros")
                                } else {
                                    ForEach(viewModel.reportsByAuthor.keys.sorted(), id: \.self) { author in
                                        ReportCaretakerCount(name: author, count: viewModel.reportsByAuthor[author] ?? 0)
                                    }
                                    .frame(maxWidth: .infinity)
                                }
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
                        
                        if viewModel.nonEmptyCategories.isEmpty {
                            Text("Não há registros para esse periodo")
                        } else {
                            ForEach(viewModel.nonEmptyCategories, id: \.name) { category in
                                CategoryReportCard(categoryName: category.name, categoryIconName: category.icon, reports: category.reports)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .background(.blue80)
        .onAppear {
            loadPDF()
        }
        .onChange(of: viewModel.timeRange) { _ in
            loadPDF()
        }
    }
    
    func loadPDF() {
        Task { @MainActor in
            let pdfCreator = PDFCreator()
            pdfURL = pdfCreator.createDailyReportPDF(from: viewModel)
        }
    }
    
    @ViewBuilder
    func CircleCapsule(text: String, icon: String) -> some View {
        HStack {
            Text(text)
                .fontDesign(.rounded)
                .font(.system(size: 15))
                .foregroundStyle(.pureWhite)
                .padding(.vertical, 8)
                .padding(.horizontal, 10)
            
            Circle()
                .foregroundStyle(.pureWhite)
                .overlay {
                    Image(systemName: icon)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                        .foregroundStyle(.blue30)
                }
                .frame(height: 30)
                .padding(.trailing, 2)
                .padding(.vertical, 2)
        }
        .background {
            Capsule()
                .frame(height: 34)
                .foregroundStyle(.blue30)
        }
    }
}

//#Preview {
//    DailyReportAppView()
//}
