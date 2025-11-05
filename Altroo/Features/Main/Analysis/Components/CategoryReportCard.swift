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
    let reports: [String]
    
    @State var isOpen: Bool = true
    
    var body: some View {
        VStack {
            
            //HEADER
            UnevenRoundedRectangle(topLeadingRadius: 20, topTrailingRadius: 20)
                .foregroundStyle(.blue30)
                .overlay {
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
                    .padding()
                }
            
            
            //CONTENT
            if isOpen {
                
            }

            
        }
    }
}
//
//#Preview {
//    CategoryReportCard(categoryName: "Fezes", reports: [])
//}
