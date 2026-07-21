//
//  PoemCategory.swift
//  FarewellToUlster
//
//  Created by Michael Scott on 13/05/2026.
//

import Foundation

/*
    declarative – assertive, making clear statements
    elliptical – intentionally obscure or leaving things unsaid
    incantatory – rhythmic, chant-like, hypnotic
    conversational – casual, everyday speech tone
    fragmentary – composed of incomplete or broken pieces
    aphoristic – concise and full of meaning, like a proverb
    associative – following thoughts or images loosely connected
    introspective – inward-looking, self-reflective
    disjunctive – jumping between ideas or images without clear transitions
    objective – emotionally detached, presenting facts or scenes
    lyrical – personal and musical, often expressive of emotion
    meditative – thoughtful, reflective, contemplative
    rhetorical – persuasive or dramatic, often addressing the audience directly
    surreal – dream-like, illogical, strange
    didactic – intended to instruct or moralize
    paratactic – listing ideas without logical connectors (like Hemingway prose)
    monologic – single voice, uninterrupted by others
    ironic – saying the opposite of what’s meant, often dry or biting
    ambiguous – open to multiple interpretations
 */

/// Each poem is assirned to a category.
enum PoemCategory: String {
    case complaint
    case descriptive
    case ironic
    case lament
    case lyric
    case narrative
}

extension PoemCategory: RawRepresentable {}

extension PoemCategory: Codable {}

extension PoemCategory: CaseIterable {}

extension PoemCategory: Identifiable {
    var id: String {
        rawValue
    }
}
