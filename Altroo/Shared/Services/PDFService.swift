import SwiftUI
import PDFKit

@MainActor
struct PDFCreator {
    func createDailyReportPDF(
        from viewModel: DailyReportViewModel,
        pageSize: CGSize = CGSize(width: 595, height: 842)
    ) -> URL? {
        
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("report.pdf")
        UIGraphicsBeginPDFContextToFile(url.path, CGRect(origin: .zero, size: pageSize), nil)
        UIGraphicsBeginPDFPage()
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        let margin: CGFloat = 24
        let usableHeight = pageSize.height - margin * 2
        var currentY: CGFloat = margin
        
        func render<V: View>(_ view: V, maxWidth: CGFloat) {
            //measure view height
            let hosting = UIHostingController(rootView: view)
            let targetSize = hosting.sizeThatFits(in: CGSize(width: maxWidth, height: .infinity))
            
            //new page if it doesnt fit
            if currentY + targetSize.height > usableHeight + margin {
                UIGraphicsBeginPDFPage()
                currentY = margin
            }
            
            //renders content
            let renderer = ImageRenderer(content: view.frame(width: maxWidth, height: targetSize.height))
            
            context.saveGState()
            context.translateBy(x: margin, y: currentY + targetSize.height)
            context.scaleBy(x: 1, y: -1)
            
            renderer.render { _, renderContext in
                renderContext(context)
            }
            
            context.restoreGState()
            currentY += targetSize.height + 16
        }
        
        let contentWidth = pageSize.width - margin * 2
        
        // HEADER
        render(
            ExportableReportHeader(
                title: "Relatório Diário",
                registerStartDate: viewModel.startDate,
                registerStartTime: viewModel.startTime,
                registerEndTime: viewModel.endTime,
                exportDate: .now
            ),
            maxWidth: contentWidth
        )
        
        // COUNT
        render(ReportCountView(viewModel: viewModel), maxWidth: contentWidth)
        
        // CATEGORIES
        for category in viewModel.nonEmptyCategories {
            render(
                CategoryReportSection(
                    categoryName: category.name,
                    categoryIconName: category.icon,
                    reports: category.reports
                ),
                maxWidth: contentWidth
            )
        }
        
        UIGraphicsEndPDFContext()
        return url
    }
}

