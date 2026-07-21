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

#Preview {
    @Previewable @State var navigation = Navigation()
    @Previewable @State var previewer = Previewer()
    let poems = previewer.poems
    let pairs = PoemSimilarity(threshold: 0.5).similarPoemPairs(poems: previewer.poems.sorted())
    PoemPairView(pair: pairs.first!)
}
