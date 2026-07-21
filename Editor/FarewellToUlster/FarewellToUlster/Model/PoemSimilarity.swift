//
//  PoemSimilarity.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 04/06/2026.
//

import Foundation
import NaturalLanguage

protocol PoemSimilarityProtocol {
    static var sentenceEmbedding: NLEmbedding? { get }
    var threshold: Double { get }
    func similarity(_ poem1: Poem, _ poem2: Poem) -> Double
    func similarPair(_ poem1: Poem, _ poem2: Poem) -> PoemPair?
    func similarPoemPairs(poems: [Poem]) -> [PoemPair]
}

class PoemSimilarity: PoemSimilarityProtocol {
    static let sentenceEmbedding = NLEmbedding.sentenceEmbedding(for: .english)
    var threshold: Double = 0.0
    private var similarityCache: [String: Double]
    
    init(threshold: Double = 0.0) {
        self.threshold = threshold
        self.similarityCache = [:]
    }
    
    func similarity(_ poem1: Poem, _ poem2: Poem) -> Double {
        let key = PoemPair.pairIdentifier(poem1, poem2)
        if let cached = similarityCache[key] { return cached }
        guard let sentenceEmbedding = Self.sentenceEmbedding,
              let vector1 = sentenceEmbedding.vector(for: poem1.text),
              let vector2 = sentenceEmbedding.vector(for: poem2.text) else { return 0.0 }
        let similarity = cosineSimilarity(a: vector1, b: vector2)
        similarityCache[key] = similarity
        return similarity
    }
    
    func similarPair(_ poem1: Poem, _ poem2: Poem) -> PoemPair? {
        let similarity = similarity(poem1, poem2)
        if similarity < threshold { return nil }
        return PoemPair(poem1: poem1, poem2: poem2, similarity: similarity)
    }
    
    func similarPoemPairs(poems: [Poem]) -> [PoemPair] {
        var pairs: [PoemPair] = []
        
        for i in poems.indices {
            for j in (i + 1)..<poems.count {
                guard let pair = similarPair(poems[i], poems[j]) else { continue }
                pairs.append(pair)
            }
        }

        return pairs.sorted()
    }

    /// Dot Product
    private func dot(_ a: [Double], _ b: [Double]) -> Double {
        assert(a.count == b.count, "Vectors must have the same dimension")
        let result = zip(a, b)
            .map { $0 * $1 }
            .reduce(0, +)

        return result
    }

    /// Magnitude
    private func mag(_ vector: [Double]) -> Double {
        // Magnitude of the vector is the square root of the dot product of the vector with itself.
        return sqrt(dot(vector, vector))
    }

    /// Returns the similarity between two vectors
    ///
    /// - Parameters:
    ///     - a: The first vector
    ///     - b: The second vector
    public func cosineSimilarity(a: [Double], b: [Double]) -> Double {
        return dot(a, b) / (mag(a) * mag(b))
    }
}
