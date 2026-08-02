//
//  SortVector.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import Foundation

/// Initialised with an array of indexes which indicate which positions in the vector are significant. 
struct SortVector {
    // These need to be in ascending order so that the < will work.
    let sortIndexes: [Int]
}

extension SortVector: Comparable {
    static func == (lhs: SortVector, rhs: SortVector) -> Bool {
        lhs.sortIndexes == rhs.sortIndexes
    }
    
    static func < (lhs: SortVector, rhs: SortVector) -> Bool {
        let l = lhs.sortIndexes
        let r = rhs.sortIndexes
        var i = 0, j = 0
        // Walk both sorted index lists together. Since a smaller index means a
        // higher-priority subject, the first list whose next subject index is
        // smaller is the one that "wins" — it has a higher-priority subject that
        // the other side doesn't have at this point. If the next indices match,
        // both sides share that subject, so move on and compare the next ones.
        while i < l.count && j < r.count {
            if l[i] == r[j] {
                i += 1; j += 1
            } else {
                return l[i] > r[j]
            }
        }
        return l.count < r.count
    }
}
