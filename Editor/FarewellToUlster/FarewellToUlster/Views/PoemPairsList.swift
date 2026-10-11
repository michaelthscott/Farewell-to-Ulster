//
//  PoemPairsList.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 05/06/2026.
//

import SwiftUI
import SwiftData

struct PoemPairsList: View {
    let pairs: [PoemPair]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(pairs) { pair in
                    NavigationLink(value: pair) {
                        HStack {
                            Text(pair.poem1.title)
                            Text("&")
                            Text(pair.poem2.title)
                        }
                    }
                }
            }
            .navigationDestination(for: PoemPair.self) { pair in
                PoemPairView(pair: pair)
            }
            .navigationTitle("Similar Poems")
        }
    }
}

#if DEBUG
#Preview(traits: .sampleData) {
    @Previewable @State var navigation = Navigation()
    @Previewable @Environment(Storage.self) var storage
    let pairs = PoemSimilarity(threshold: 0.5).similarPoemPairs(poems: storage.poems.sorted())
    PoemPairsList(pairs: pairs)
}
#endif
