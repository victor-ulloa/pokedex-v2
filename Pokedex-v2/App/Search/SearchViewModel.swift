//
//  SearchViewModel.swift
//  Pokedex-v2
//
//  Created by Victor Ulloa on 2024-03-31.
//

import Combine

final class SearchViewModel: ObservableObject {
    
    @Published var index: Int = 0
    @Published var pokemonListResponse : PokemonListResponse?
    @Published var pokemonListItems: [PokemonListItem] = []
    
    private var cancellable: AnyCancellable?
    
    init() {
        cancellable = $index.sink { [weak self] value in
            NetworkManager.instance.getPokemonList(offset: 0, limit: 20) { [weak self] response in
                self?.pokemonListResponse = response
                self?.pokemonListItems.append(contentsOf: response.results)
            }
        }
    }
    
}
