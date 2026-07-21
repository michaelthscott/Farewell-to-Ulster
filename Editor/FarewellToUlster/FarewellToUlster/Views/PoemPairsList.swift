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

#Preview {
    @Previewable @State var navigation = Navigation()
    @Previewable @State var previewer = Previewer()
    let poems = previewer.poems
    let pairs = PoemSimilarity(threshold: 0.5).similarPoemPairs(poems: previewer.poems.sorted())
    PoemPairsList(pairs: pairs)
}
