//
//  PoemsList.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import SwiftUI

/// A view that lists some poems.
struct PoemsList: View {
    let poems: [Poem]

    var body: some View {
        List {
            ForEach(poems) { poem in
                NavigationLink(value: Path.poem(poem)) {
                    Text(poem.title)
                }
            }
        }
        .navigationDestination(for: Path.self) { path in
            DestinationView(path: path)
        }
    }
}

#Preview {
    @Previewable @State var navigation = Navigation()
    @Previewable @State var previewer = Previewer()
    var poems = previewer.poems
    poems.insert(poems[0], at: 1)
    return NavigationStack(path: $navigation.poemsPath) {
        PoemsList(poems: Array(poems[1...2]))
        .navigationDestination(for: Path.self) { path in
            DestinationView(path: path)
        }
    }
    .environment(navigation)
}
