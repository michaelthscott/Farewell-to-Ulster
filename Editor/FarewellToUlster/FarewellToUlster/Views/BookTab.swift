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
    @Environment(Storage.self) private var storage
    @State private var showExporter: Bool = false
    @State private var document: Document?
    @State private var contentType: UTType = .pdf
    @State private var defaultFileName: String = "Untitled"
    @State private var isCommittingUpdate: Bool = false

    var body: some View {
        NavigationStack {
            BookView()
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Menu {
                            Button(action: {
                                Task {
                                    isCommittingUpdate = true
                                    await commitUpdate()
                                    isCommittingUpdate = false
                                }
                            }) {
                                Label("Commit update", systemImage: "square.and.arrow.down")
                            }
                            Button(action: {
                                Task {
                                    await exportPDF()
                                }
                            }) {
                                Label("Export PDF", systemImage: "square.and.arrow.up")
                            }
                        } label: {
                            Label("Export", systemImage: "ellipsis.circle")
                        }
                    }
                }
                .overlay {
                    if isCommittingUpdate {
                        Color.black.opacity(0.3).ignoresSafeArea()
                        ProgressView("Committing update …")
                            .padding(24)
                            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
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
    
    private func commitUpdate() async {
        guard let jsonFile = JSONFile(storage: storage) else {
            print("Failed to get JSON file")
            return
        }

        guard let data = try? jsonFile.document.snapshot(contentType: jsonFile.contentType) else {
            return
        }
        
        let localFile = LocalFile(path: "Editor/FarewellToUlster/FarewellToUlster/Assets.xcassets/Farewell-to-Ulster.dataset/Farewell-to-Ulster.json",
                                  content: data)
        
        var localFiles: [LocalFile] = [localFile]
        var eraNumber: Int = 1

        for era in storage.eras.sorted() {
            let mdEra = MDEra(number: eraNumber, title: era.title, text: era.text)
            localFiles.append(LocalFile(path: mdEra.path, content: mdEra.data))
            guard let poems = era.poems else { continue }
            var poemNumber = 1
            for poem in poems.vectorSorted() {
                let mdPoem = MDPoem(eraPaddedNumber: mdEra.paddedNumber, number: poemNumber, title: poem.title, text: poem.text)
                localFiles.append(LocalFile(path: mdPoem.path, content: mdPoem.data))
                poemNumber += 1
            }
            eraNumber += 1
        }
        let client = GitHubClient(owner: "michaelthscott", repo: "Farewell-to-Ulster", branch: "main")
        do {
            _ = try await client.batchCommit(files: localFiles, message: "Update from Editor")
        } catch {
            print("Update failed: \(error.localizedDescription)")
        }
    }
    
    private func exportPDF() async {
        guard let book = storage.book else { return }
        let renderer = PDFRenderer()
        let data: Data = await renderer.render(pages: Pages(storage: storage).pages)
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
        .environment(previewer.storage)
}
