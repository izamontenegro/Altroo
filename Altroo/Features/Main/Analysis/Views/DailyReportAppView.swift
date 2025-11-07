//
//  DailyReportAppView.swift
//  Altroo
//
//  Created by Raissa Parente on 04/11/25.
//

import SwiftUI

struct DailyReportAppView: View {
    @ObservedObject var viewModel: DailyReportViewModel
    
    var body: some View {
        VStack (spacing: 16) {
            //SUBHEADER
            HStack(alignment: .bottom) {
                TimeSection(text: "Data", dataSource: $viewModel.startDate, type: .date)
                Spacer()
                TimeSection(text: "Hora Inicial", dataSource: $viewModel.startTime, type: .time)
                Image(systemName: "arrow.right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14)
                    .padding(.bottom, 10)
                TimeSection(text: "Hora Final", dataSource: $viewModel.endTime, type: .time)
            }
            .padding(Layout.standardSpacing)
            .background(.blue70)
            .clipShape(
                RoundedRectangle(cornerRadius: 20)
            )
            .onChange(of: viewModel.startDate) { _ in viewModel.feedArrays() }
            .onChange(of: viewModel.startTime) { _ in viewModel.feedArrays() }
            .onChange(of: viewModel.endTime) { _ in viewModel.feedArrays() }
            
            ScrollView {
                //TITLE
                HStack {
                    StandardLabelRepresentable(
                        labelFont: .sfPro,
                        labelType: .title2,
                        labelWeight: .semibold,
                        text: "Relatório Diário",
                        color: UIColor.black10
                    )
                    //                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    
                    Button {
                        
                    } label: {
                        Text("Exportar")
                    }
                }
                
                //COUNT
                HStack {
                    VStack {
                        SectionTitle("Contagem")
                        
                        VStack {
                            Text("\(viewModel.combinedRecords.count)")
                                .font(.largeTitle)
                            Text("Registros")
                                .font(.callout)
                                .fixedSize(horizontal: true, vertical: false)
                        }
                        .padding(Layout.standardSpacing)
                        .frame(maxWidth: .infinity, minHeight: 100, alignment: .top)
                        .fontDesign(.rounded)
                        .foregroundStyle(.black10)
                        .background(.pureWhite)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                    VStack {
                        SectionTitle("Registros por cuidador")
                        
                        VStack {
                            ForEach(viewModel.reportsByAuthor.keys.sorted(), id: \.self) { author in
                                CaretakerCount(for: author, count: viewModel.reportsByAuthor[author] ?? 0)
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
                SectionTitle("Histórico de Registros")
                ForEach(viewModel.nonEmptyCategories, id: \.name) { category in
                    CategoryReportCard(categoryName: category.name, categoryIconName: category.icon, reports: category.reports)
                }
            }
            .padding(.horizontal)
        }
        .background(.blue80)
    }
    
    @ViewBuilder
    func TimeSection(text: String, dataSource: Binding<Date>, type: UIDatePicker.Mode) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(text)
                .font(.callout)
                .fontDesign(.rounded)
                .foregroundStyle(.black10)
            UIDatePickerWrapper(date: dataSource, type: type)
                .frame(height: 35)
                .frame(width: type == .time ? 80 : 150)
        }
    }
    
    @ViewBuilder
    func SectionTitle(_ text: String) -> some View {
        StandardLabelRepresentable(
            labelFont: .sfPro,
            labelType: .title3,
            labelWeight: .medium,
            text: text,
            color: UIColor.blue20
        )
    }
    
    
    @ViewBuilder
    func CaretakerCount(for name: String, count: Int) -> some View {
        VStack(spacing: 0) {
            HStack {
                Text(name)
                    .font(.callout)
                Spacer()
                
                Text("\(count) registros")
                    .font(.footnote)
                    .foregroundStyle(.black30)
            }
            Divider()
        }
    }
}

//#Preview {
//    DailyReportAppView()
//}
