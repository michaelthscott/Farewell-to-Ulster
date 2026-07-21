//
//  SortVector.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import Foundation

/// Initialised with an array of indexes which indicate which positions in the vector are significant. 
struct SortVector {
    let sortIndexes: [Int]
        
    var string: String {
        guard let maxSortIndex = sortIndexes.max() else {
            return ""
        }
        let length = maxSortIndex + 1
        var array: [String] = Array(repeating: "0", count: length)
        for sortIndex in sortIndexes {
            // TODO: For now just avoid any out of bounds error.
            if sortIndex < length {
                array[sortIndex] = "1"
            } else {
                // TODO: Maybe throw an error.
                print("Sort index out of bounds: \(sortIndex)")
            }
        }
        return array.joined()
    }
}

extension SortVector: Comparable {
    static func == (lhs: SortVector, rhs: SortVector) -> Bool {
        lhs.sortIndexes == rhs.sortIndexes
    }
    
    static func < (lhs: SortVector, rhs: SortVector) -> Bool {
        lhs.string < rhs.string
    }
}
