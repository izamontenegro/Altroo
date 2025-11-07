//
//  CategoryReportCard.swift
//  Altroo
//
//  Created by Raissa Parente on 04/11/25.
//

import SwiftUI

struct CategoryReportCard: View {
    let categoryName: String
    let categoryIconName: String
    let reports: [ReportItem]
    
    @State var isOpen: Bool = true
    
    var body: some View {
        VStack(spacing: 0) {
            //HEADER
            HStack {
                Image(systemName: categoryIconName)
                    .foregroundStyle(.white)
                
                StandardLabelRepresentable(
                    labelFont: .sfPro,
                    labelType: .body,
                    labelWeight: .semibold,
                    text: categoryName,
                    color: UIColor.white
                )
                
                Button {
                    isOpen.toggle()
                } label: {
                    Image(systemName: isOpen ? "chevron.up" : "chevron.down")
                        .foregroundStyle(.white)
                }
            }
            .padding(8)
            .background(.blue30)
            
            VStack {
                //CONTENT
                if isOpen {
                    VStack {
                        ForEach(reports) { report in
                            configureItem(report)
                                .onAppear {
                                    print(report.base.reportTitle)
                                }
                            
                            Divider()
                        }
                        .padding(.horizontal, 10)
                    }
                    .padding(.top, 10)
                }
            }
            .background(.pureWhite)
        }
        .clipShape(
            RoundedRectangle(cornerRadius: 10)
        )
    }
    
    @ViewBuilder
    func configureItem(_ item: ReportItem) -> some View {
        if let time = item.base.reportTime, let author = item.base.reportAuthor {
            switch item {
            case .stool(let stoolRecord):
                DailyReportItem(title: item.base.reportTitle, stoolColoration: stoolRecord.colorType, observation: item.base.reportNotes, time: time, author: author)
            case .urine(let urineRecord):
                DailyReportItem(title: item.base.reportTitle, urineColoration: urineRecord.colorType, observation: item.base.reportNotes, time: time, author: author)
            case .feeding(let feedingRecord):
                DailyReportItem(title: item.base.reportTitle, reception: feedingRecord.amountEaten, observation: item.base.reportNotes, time: time, author: author)
            case .hydration(let hydrationRecord):
                DailyReportItem(title: item.base.reportTitle, observation: nil, time: time, author: author)
            case .task(let taskInstance):
                DailyReportItem(title: item.base.reportTitle, observation: item.base.reportNotes, time: time, author: author)
            case .symptom(let symptom):
                DailyReportItem(title: item.base.reportTitle, observation: item.base.reportNotes, time: .now, author: author)
            }
        }
    }
}


//
//#Preview {
//    CategoryReportCard(categoryName: "Fezes", reports: [])
//}
