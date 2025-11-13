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
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        isOpen.toggle()
                    }
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
                        ForEach(Array(reports.enumerated()), id: \.element.id) { index, report in
                            configureItem(report)
                            
                            if index < reports.count - 1 {
                                Divider()
                            }
                        }
                    }
                    .padding(10)
                }
            }
            .background(.pureWhite)
        }
        .clipShape(
            RoundedRectangle(cornerRadius: 10)
        )
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: isOpen)
        
    }
    
    @ViewBuilder
    func configureItem(_ item: ReportItem) -> some View {
        if let time = item.base.reportTime, let author = item.base.reportAuthor {
            switch item {
            case .stool(let stoolRecord):
                ReportItemRow(title: item.base.reportTitle, stoolColoration: stoolRecord.colorType, observation: item.base.reportNotes, time: time, author: author)
            case .urine(let urineRecord):
                ReportItemRow(title: item.base.reportTitle, urineColoration: urineRecord.colorType, observation: item.base.reportNotes, time: time, author: author)
            case .feeding(let feedingRecord):
                ReportItemRow(title: item.base.reportTitle, reception: feedingRecord.amountEaten, observation: item.base.reportNotes, time: time, author: author)
            case .hydration(let hydrationRecord):
                ReportItemRow(title: item.base.reportTitle, observation: nil, time: time, author: author)
            case .task(let taskInstance):
                ReportItemRow(title: item.base.reportTitle, observation: item.base.reportNotes, time: time, author: author)
            case .symptom(let symptom):
                ReportItemRow(title: item.base.reportTitle, observation: item.base.reportNotes, time: time, author: author)
            }
        }
    }
}


//
//#Preview {
//    CategoryReportCard(categoryName: "Fezes", reports: [])
//}
