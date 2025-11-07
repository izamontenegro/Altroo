import SwiftUI
import PDFKit

@MainActor
struct PDFCreator {
 func createPDF<V: View>(
        from view: V,
        pageSize: CGSize = CGSize(width: 595, height: 842)
    ) -> URL? {
        //measure SwiftUI view height off-screen
        let hosting = UIHostingController(rootView: view)
        let targetSize = hosting.sizeThatFits(
            in: CGSize(width: pageSize.width, height: .infinity)
        )
        hosting.view.bounds = CGRect(origin: .zero, size: targetSize)
        
        //renderer for SwiftUI content
        let renderer = ImageRenderer(
            content: view
                .frame(width: pageSize.width, height: targetSize.height)
        )
        
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("report.pdf")
        UIGraphicsBeginPDFContextToFile(url.path, CGRect(origin: .zero, size: pageSize), nil)
        
        let totalHeight = targetSize.height
        let pageHeight = pageSize.height
        
        var currentY: CGFloat = 0
        
        while currentY < totalHeight {
            UIGraphicsBeginPDFPage()
            guard let context = UIGraphicsGetCurrentContext() else { break }
            
            //flip context once to match SwiftUI coordinate system
            context.saveGState()
            context.translateBy(x: 0, y: pageSize.height)
            context.scaleBy(x: 1, y: -1)
            
            //draw the portion that starts *from the top* of the document
            let pageOriginY = totalHeight - currentY - pageHeight
            context.translateBy(x: 0, y: -max(pageOriginY, 0))
            
            renderer.render { _, renderContext in
                renderContext(context)
            }
            
            context.restoreGState()
            
            currentY += pageHeight
        }
        
        UIGraphicsEndPDFContext()
        return url
    }
}
