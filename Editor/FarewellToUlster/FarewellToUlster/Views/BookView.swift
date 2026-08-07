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
    @Environment(Storage.self) private var storage

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
        guard let era = navigation.selectedEra else {
            return Pages(storage: storage).pages
        }
        return Pages(storage: storage).pages(for: era)
    }
}

#Preview {
    @Previewable @State var navigation = Navigation()
    @Previewable @State var previewer = Previewer()
    BookView()
        .environment(navigation)
        .environment(previewer.storage)
        .modelContainer(previewer.storage.container)
}
