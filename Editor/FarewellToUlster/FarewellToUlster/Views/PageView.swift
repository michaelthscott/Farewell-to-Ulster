//
//  PageView.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import SwiftUI

/// A view that displays a Page.
struct PageView<Content: View>: View, Identifiable  {
    var id: UUID = UUID()
    var header: String = ""
    var footer: String = ""
    @ViewBuilder var content: Content
    
    var body: some View {
        VStack {
            Text(header)
                .font(.caption)
            Spacer()
            Group(subviews: content) { subviews in
                ForEach(subviews: subviews) { subview in
                    subview
                }
            }
            Spacer()
            Text(footer)
                .font(.caption)
        }
    }
}

#Preview {
    PageView(header: "My Page", footer: "Page 1") {
        Text("ABC")
            .font(.largeTitle)
        Text("This is the story of the alphabet")
            .font(.body)
    }
}
