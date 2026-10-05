import Cocoa
import WebKit
import PDFKit

class PDFCreator {
    
    /**
     Creates a PDF using the given HTML content and saves it to the user's document directory.
     - returns: The generated PDF path.
     */
    class func create(htmlContent: String, width: Double, height: Double, orientation: String, margins: [Int]?) -> URL {
        guard let htmlData = htmlContent.data(using: .utf8) else {
            fatalError("Failed to convert HTML content to data")
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(data: htmlData, options: options, documentAttributes: nil) else {
            fatalError("Failed to create attributed string from HTML")
        }
        
        let pageSize = NSSize(width: width, height: height)
        let marginLeft = CGFloat(margins?[0] ?? 50)
        let marginTop = CGFloat(margins?[1] ?? 50)
        let marginRight = CGFloat(margins?[2] ?? 50)
        let marginBottom = CGFloat(margins?[3] ?? 50)
        
        let pdfData = NSMutableData()
        
        var mediaBox = CGRect(x: 0, y: 0, width: pageSize.width, height: pageSize.height)
        guard let dataConsumer = CGDataConsumer(data: pdfData as CFMutableData),
              let context = CGContext(consumer: dataConsumer, mediaBox: &mediaBox, nil) else {
            fatalError("Could not create PDF context")
        }
        
        let pdfInfo = [kCGPDFContextMediaBox as String: mediaBox] as CFDictionary
        context.beginPDFPage(pdfInfo)
        
        let drawingRect = CGRect(
            x: marginLeft,
            y: marginTop,
            width: pageSize.width - marginLeft - marginRight,
            height: pageSize.height - marginTop - marginBottom
        )
        
        let nsContext = NSGraphicsContext(cgContext: context, flipped: false)
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = nsContext
        
        NSBezierPath(rect: drawingRect).addClip()
        
        attributedString.draw(with: drawingRect, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        
        NSGraphicsContext.restoreGraphicsState()
        context.endPDFPage()
        context.closePDF()
        
        guard nil != (try? pdfData.write(to: createdFileURL, options: .atomic)) else {
            fatalError("Failed to write PDF data to file")
        }
        
        return createdFileURL
    }
    
    /**
     Creates temporary PDF document URL
     */
    private class var createdFileURL: URL {
        guard let directory = try? FileManager.default.url(for: .documentDirectory, 
                                                          in: .userDomainMask, 
                                                          appropriateFor: nil, 
                                                          create: true)
            else { fatalError("Error getting user's document directory.") }
        
        let url = directory.appendingPathComponent("generatedPdfFile").appendingPathExtension("pdf")
        return url
    }
}
