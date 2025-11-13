//
//  CategoryReportSection.swift
//  Altroo
//
//  Created by Raissa Parente on 07/11/25.
//

import SwiftUI

struct CategoryReportSection: View {
    let categoryName: String
    let categoryIconName: String
    let reports: [ReportItem]
    
    var body: some View {
        VStack(alignment:.leading, spacing: 0) {
            //HEADER
            HStack {
                Image(systemName: categoryIconName)
                    .foregroundStyle(.blue20)
                
                Text(categoryName)
                    .font(.title3)
                    .foregroundStyle(.blue20)
            }
            Divider()
                .overlay(.blue20)
            
            //CONTENT
            VStack {
                VStack {
                    ForEach(Array(reports.enumerated()), id: \.element.id) { index, report in
                        configureItem(report)
                        
                        if index < reports.count - 1 {
                                Divider()
                        }
                    }
                    .padding(.horizontal, 10)
                }
                .padding(.top, 10)
            }
        }
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
