//
//  PokemonListResponse.swift
//  Pokedex-v2
//
//  Created by Victor Ulloa on 2024-03-31.
//

import Foundation

struct PokemonListResponse: Codable {
    
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonListItem]
    
}

struct PokemonListItem: Codable, Identifiable {
    
    let id = UUID()
    let name: String
    let url: String
    
}
