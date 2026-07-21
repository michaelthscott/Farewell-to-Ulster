//
//  PDFRenderer.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import SwiftUI
import SwiftData

//https://www.hackingwithswift.com/quick-start/swiftui/how-to-render-a-swiftui-view-to-a-pdf

final class PDFRenderer {
    
    func render(pages: [Page]) async -> Data {
        guard pages.isEmpty == false else { return Data() }
        guard let mutableData = CFDataCreateMutable(nil, 0) else { return Data() }
        var pageRect = CGRect(x: 0, y: 0, width: 600, height: 800)
        guard let consumer = CGDataConsumer(data: mutableData),
              let pdfContext = CGContext(consumer: consumer, mediaBox: &pageRect, nil) else { return Data() }
        for page in pages {
            pdfContext.beginPDFPage(nil)
            switch page.type {
            case .book(let book):
                let imageRenderer = ImageRenderer(content: VStack(alignment: .center) {
                    Text(book.title)
                        .font(.largeTitle)
                        .fontDesign(.serif)
                        .padding([.bottom], 2)
                    Text(book.author)
                        .font(.body)
                        .fontDesign(.serif)
                }
                    .padding()
                    .frame(width: pageRect.width, height: pageRect.height))
                imageRenderer.render { size, renderer in
                    renderer(pdfContext)
                }
                pdfContext.endPDFPage()
            case .era(let book, let era):
                let imageRenderer = ImageRenderer(content: VStack(alignment: .center) {
                    Text(book.title)
                        .font(.caption)
                        .fontDesign(.serif)
                    Spacer()
                    Text(era.title)
                        .font(.title)
                        .fontDesign(.serif)
                        .padding([.bottom], 4)
                    Text(era.text)
                        .font(.body)
                        .italic()
                        .fontDesign(.serif)
                    Spacer()
                    Text("\(page.number)")
                        .font(.caption)
                }
                    .padding()
                    .frame(width: pageRect.width, height: pageRect.height))
                imageRenderer.render { size, renderer in
                    renderer(pdfContext)
                }
                pdfContext.endPDFPage()
            case .poem(let book, let era, let poem):
                let imageRenderer = ImageRenderer(content: VStack {
                    VStack(alignment: .center) {
                        Text("\(book.title): \(era.title)")
                            .font(.caption)
                            .fontDesign(.serif)
                        Spacer()
                        VStack(alignment: .leading) {
                            Text(poem.title)
                                .font(.title2)
                                .fontDesign(.serif)
                                .padding([.bottom], 6)
                            Text(poem.text)
                                .font(.body)
                                .fontDesign(.serif)
                        }
                        Spacer()
                        Text("\(page.number)")
                            .font(.caption)
                            .fontDesign(.serif)
                    }
                }
                    .padding()
                    .frame(width: pageRect.width, height: pageRect.height))
                imageRenderer.render { size, renderer in
                    renderer(pdfContext)
                }
                pdfContext.endPDFPage()
            case .empty:
                let imageRenderer = ImageRenderer(content: VStack(alignment: .center) {
                    Spacer()
                    Text("\(page.number)")
                        .font(.caption)
                        .fontDesign(.serif)
                }
                    .padding()
                    .frame(width: pageRect.width, height: pageRect.height))
                imageRenderer.render { size, renderer in
                   renderer(pdfContext)
                }
                pdfContext.endPDFPage()
            }
        }
        pdfContext.closePDF()
        return mutableData as Data
    }
}
