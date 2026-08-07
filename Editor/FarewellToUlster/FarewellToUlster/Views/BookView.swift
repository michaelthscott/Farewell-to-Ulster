//
//  BookView.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 06/08/2026.
//

import SwiftUI
import SwiftData

struct BookView: View {
    @Environment(Navigation.self) private var navigation
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        @Bindable var navigation = navigation
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
}

#Preview {
    @Previewable @State var navigation = Navigation()
    @Previewable @State var previewer = Previewer()
    BookView()
        .environment(navigation)
        .modelContainer(previewer.storage.container)
}
