//
//  PoemPairView.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 12/06/2026.
//

import SwiftUI

struct PoemPairView: View {
    let pair: PoemPair
    
    var body: some View {
        List {
            ForEach(([pair.poem1, pair.poem2])) { poem in
                Text(poem.title)
                    .font(.title)
                Text(poem.text)
                    .font(.body)
            }
        }
    }
}

#if DEBUG
#Preview(traits: .sampleData) {
    @Previewable @State var navigation = Navigation()
    @Previewable @Environment(Storage.self) var storage
    let pairs = PoemSimilarity(threshold: 0.5).similarPoemPairs(poems: storage.poems.sorted())
    PoemPairView(pair: pairs.first!)
}
#endif
