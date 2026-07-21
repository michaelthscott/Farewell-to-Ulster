//
//  PoemSearchTokenView.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 29/05/2026.
//

import SwiftUI

struct PoemSearchTokenView: View {
    var token: PoemSearchToken

    var body: some View {
        switch token {
        case .status:
            return Text(token.rawValue)
                .foregroundColor(.blue)
        case .category:
            return Text(token.rawValue)
                .foregroundColor(.green)
        default:
            return Text(token.rawValue)
                .foregroundColor(.red)
        }
    }
}

#Preview {
    PoemSearchTokenView(token: .status(.almostFinished))
}
