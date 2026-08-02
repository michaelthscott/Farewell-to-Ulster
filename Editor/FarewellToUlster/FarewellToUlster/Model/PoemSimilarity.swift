//
//  PoemSimilarity.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 04/06/2026.
//

import Foundation
import NaturalLanguage
import Accelerate

protocol PoemSimilarityProtocol {
    static var sentenceEmbedding: NLEmbedding? { get }
    var threshold: Float { get }
    func similarPoemPairs(poems: [Poem]) -> [PoemPair]
}

class PoemSimilarity: PoemSimilarityProtocol {
    struct PoemEmbedding {
        let poem: Poem
        let vector: [Float]
    }

    static let sentenceEmbedding = NLEmbedding.sentenceEmbedding(for: .english)
    var threshold: Float
    
    init(threshold: Float = 0.0) {
        self.threshold = threshold
    }
        
    func similarPoemPairs(poems: [Poem]) -> [PoemPair] {
        guard let embedding = Self.sentenceEmbedding else { return [] }
        var embeddings: [PoemEmbedding] = []
        embeddings.reserveCapacity(poems.count)
        
        // Embed each poem once, normalizing so cosine similarity reduces to a dot product later.
        for poem in poems {
            guard let vec = embedding.vector(for: poem.text) else { continue }
            var floatVec = vec.map { Float($0) }

            // Normalize each embedding to unit length so that later, cosine similarity
            // between any two poems reduces to a plain dot product.
            //
            // cosine(A, B) = (A · B) / (‖A‖ × ‖B‖)
            //
            // If ‖A‖ = ‖B‖ = 1, the denominator becomes 1 and this simplifies to:
            //
            // cosine(A, B) = A · B
            //
            // That's what lets the pairwise comparison later become a single matrix
            // multiply (vDSP_mmul only computes raw dot products) — normalizing once
            // per poem here avoids having to divide by magnitudes on every one of the
            // ~n²/2 pairwise comparisons.
            var norm: Float = 0
            vDSP_svesq(floatVec, 1, &norm, vDSP_Length(floatVec.count))
            norm = sqrt(norm)
            if norm > 0 {
                var divisor = norm
                vDSP_vsdiv(floatVec, 1, &divisor, &floatVec, 1, vDSP_Length(floatVec.count))
            }

            embeddings.append(PoemEmbedding(poem: poem, vector: floatVec))
        }

        let n = embeddings.count
        let dim = embeddings[0].vector.count
        
        // Flatten into a single row-major [n x dim] buffer —
        // vDSP/BLAS-style routines operate on flat contiguous memory, not arrays of arrays.
        var flat = [Float](repeating: 0, count: n * dim)
        for (i, e) in embeddings.enumerated() {
            flat.replaceSubrange(i * dim ..< (i + 1) * dim, with: e.vector)
        }

        // Compute every pairwise similarity at once: flat (n x dim) × flatᵀ (dim x n) → n x n.
        // vDSP_mmul expects the second operand pre-transposed in memory (no transpose
        // flag like BLAS has), so build that [dim x n] transpose of flat first.
        var flatTransposed = [Float](repeating: 0, count: n * dim)
        flat.withUnsafeBufferPointer { src in
            flatTransposed.withUnsafeMutableBufferPointer { dst in
                vDSP_mtrans(src.baseAddress!, 1, dst.baseAddress!, 1, vDSP_Length(dim), vDSP_Length(n))
            }
        }
        
        // Single matrix multiply computes every pairwise similarity at once —
        // matrix[i * n + j] is the cosine similarity between poem i and poem j.
        var matrix: [Float] = [Float](repeating: 0, count: n * n)
        flat.withUnsafeBufferPointer { a in
            flatTransposed.withUnsafeBufferPointer { b in
                matrix.withUnsafeMutableBufferPointer { c in
                    vDSP_mmul(
                        a.baseAddress!, 1,
                        b.baseAddress!, 1,
                        c.baseAddress!, 1,
                        vDSP_Length(n), vDSP_Length(n), vDSP_Length(dim)
                    )
                }
            }
        }
        
        var candidates: [PoemPair] = []
        // Only scan the upper triangle (i < j) — matrix is symmetric, diagonal is self-similarity == 1
        for i in 0..<n {
            for j in (i + 1)..<n {
                let sim = matrix[i * n + j]
                if sim >= threshold {
                    candidates.append(PoemPair(
                        poem1: embeddings[i].poem,
                        poem2: embeddings[j].poem,
                        similarity: sim
                    ))
                }
            }
        }
        
        return candidates.sorted { $0.similarity > $1.similarity }
    }
}
