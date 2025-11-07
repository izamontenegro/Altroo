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
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Daily Care Report")
                            .font(.largeTitle)
                            .bold()
                        Text("November 7, 2025")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.bottom, 8)
                    
                    Divider()
                    
                    // Metrics section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Overview")
                            .font(.title2)
                            .bold()
                        HStack(spacing: 16) {
                            MetricCard(title: "Hydration", value: "6 cups")
                            MetricCard(title: "Meals", value: "4")
                            MetricCard(title: "Tasks Done", value: "12")
                        }
                    }
                    
                    // Multiple sections with cards
                    ForEach(0..<10) { section in
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Section \(section + 1)")
                                .font(.title3)
                                .bold()
                            ForEach(0..<3) { index in
                                ReportCard(
                                    title: "Activity \(index + 1)",
                                    detail: """
                                    Lorem ipsum dolor sit amet, consectetur adipiscing elit. \
                                    Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. \
                                    Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
                                    """
                                )
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Footer
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes")
                            .font(.title2)
                            .bold()
                        Text("""
                        Overall, the day went smoothly. Minor interruptions during the afternoon tasks. \
                        The patient maintained hydration and completed all required activities.
                        """)
                            .font(.body)
                    }
                }
                .padding(24)
                .frame(maxWidth: 500, alignment: .leading)
                .background(Color.white)
            }
        }

        struct MetricCard: View {
            let title: String
            let value: String
            
            var body: some View {
                VStack(spacing: 8) {
                    Text(value)
                        .font(.title)
                        .bold()
                    Text(title)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(white: 0.95))
                .cornerRadius(12)
                .shadow(radius: 1)
    }
}

struct ReportCard: View {
    let title: String
    let detail: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            Text(detail)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(white: 0.97))
        .cornerRadius(10)
        .shadow(radius: 0.5)
    }
}
