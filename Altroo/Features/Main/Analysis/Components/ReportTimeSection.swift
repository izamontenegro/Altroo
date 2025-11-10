//
//  ReportTimeSection.swift
//  Altroo
//
//  Created by Raissa Parente on 07/11/25.
//

import SwiftUI

struct ReportTimeSection: View {
    let text: String
    @Binding var date: Date
    let type: UIDatePicker.Mode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(text)
                .font(.callout)
                .fontDesign(.rounded)
                .foregroundStyle(.black10)
            
            UIDatePickerWrapper(date: $date, type: type)
                .frame(height: 35)
                .frame(width: type == .time ? 80 : 150)
                .preferredColorScheme(.dark)
        }
    }
}
