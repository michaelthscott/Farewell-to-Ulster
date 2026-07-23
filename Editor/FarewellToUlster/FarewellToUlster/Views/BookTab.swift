//
//  BookTab.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import Foundation
import SwiftUI
import SwiftData
import UniformTypeIdentifiers

//TODO: If there is no book then we could import a book. This would replace inserting a default book when setting up the container.

/// Display and edit the book title and author. Export the book as JSON and PDF.
struct BookTab: View {
    @Environment(Navigation.self) private var navigation
    @Environment(\.modelContext) private var modelContext
    @State private var showExporter: Bool = false
    @State private var document: Document?
    @State private var contentType: UTType = .pdf
    @State private var defaultFileName: String = "Untitled"

    var body: some View {
        @Bindable var navigation = navigation
        NavigationStack {
            TabView(selection: $navigation.pageSelection) {
                ForEach(pages) { page in
                    switch page.type {
                    case .book(let book):
                        PageView {
                            VStack(alignment: .center) {
                                Text(book.title)
                                    .font(.largeTitle)
                                    .padding([.bottom], 2)
                                Text(book.author)
                                    .font(.body)
                            }
                        }
                    case .era(let book, let era):
                        PageView(header: book.title, footer: "\(page.number)") {
                            VStack(alignment: .center) {
                                Text(era.title)
                                    .font(.title)
                                    .padding([.bottom], 4)
                                Text(era.text)
                                    .font(.body).italic()
                            }
                        }
                    case .poem(let book, let era, let poem):
                        PageView(header: "\(book.title): \(era.title)", footer: "\(page.number)") {
                            VStack(alignment: .leading) {
                                Text(poem.title)
                                    .font(.title2)
                                    .padding([.bottom], 6)
                                Text(poem.text)
                                    .font(.body)
                            }
                        }
                        .onTapGesture {
                            navigation.selectedTab = .poems
                            navigation.poemsPath.append(Path.poem(poem))
                        }
                    case .empty:
                        Text("No book")
                    }
                }
                .padding()
            }
            .tabViewStyle(.page)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Button(action: {
                            Task {
                                await commitJSON()
                            }
                        }) {
                            Label("GitHub", systemImage: "square.and.arrow.down.fill")
                        }
                        Button(action: {
                            Task {
                                saveJSON()
                            }
                        }) {
                            Label("JSON", systemImage: "square.and.arrow.down")
                        }
                        Button(action: {
                            Task {
                                await exportPDF()
                            }
                        }) {
                            Label("PDF", systemImage: "square.and.arrow.up")
                        }
                    } label: {
                        Label("Export", systemImage: "ellipsis.circle")
                    }
                }
            }
            .fileExporter(isPresented: $showExporter, document: document, contentType: contentType, defaultFilename: defaultFileName) { result in
                switch result {
                case .success(let url):
                    print("Saved to \(url)")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    var pages: [Page] {
        var pages: [Page] = []
        guard let books = try? modelContext.fetch(FetchDescriptor<Book>()),
              let book = books.first,
              let eras = try? modelContext.fetch(FetchDescriptor<Era>()) else {
            return pages
        }
        var pageNumber: Int = 0
        var selectedEras: [Era] = []
        
        if let selectedEra = navigation.selectedEra {
            selectedEras.append(selectedEra)
        } else {
            pageNumber += 1
            pages.append(Page(type: .book(book), number: pageNumber))
            selectedEras = eras.sorted()
        }
        
        for era in selectedEras {
            pageNumber += 1
            pages.append(Page(type: .era(book, era), number: pageNumber))
            guard let poems = era.poems else { continue }
            for poem in poems.vectorSorted() {
                pageNumber += 1
                pages.append(Page(type: .poem(book, era, poem), number: pageNumber))
            }
        }
        
        return pages
    }

    private func commitJSON() async {
        guard let jsonFile = JSONFile(modelContext: modelContext) else {
            print("Failed to get JSON file")
            return
        }

        let document = jsonFile.document
        
        do {
            let data = try document.snapshot(contentType: jsonFile.contentType)
            let committer = GitHubCommitter(owner: "michaelthscott", repo: "Farewell-to-Ulster")
            try await committer.commitFile(
                path: "Editor/FarewellToUlster/FarewellToUlster/Assets.xcassets/Farewell-to-Ulster.dataset/Farewell-to-Ulster.json",
                content: String(data: data, encoding: .utf8)!,
                message: "Commit from editor app"
                )
        } catch  {
            print("Commit failed: \(error.localizedDescription)")
            return
        }
    }
    
    private func saveJSON() {
        guard let jsonFile = JSONFile(modelContext: modelContext) else {
            return
        }
        document = jsonFile.document
        contentType = jsonFile.contentType
        defaultFileName = jsonFile.fileName
        showExporter = true
    }

    private func exportPDF() async {
        guard let books = try? modelContext.fetch(FetchDescriptor<Book>()),
              let book = books.first else {
            return
        }
        let renderer = PDFRenderer()
        let data: Data = await renderer.render(pages: pages)
        document = Document(data: data)
        contentType = .pdf
        defaultFileName = book.title.replacingOccurrences(of: " ", with: "-") + ".pdf"
        showExporter = true
    }
}

#Preview {
    @Previewable @State var navigation = Navigation()
    @Previewable @State var previewer = Previewer()
    BookTab()
        .environment(navigation)
        .modelContainer(previewer.storage.container)
}
