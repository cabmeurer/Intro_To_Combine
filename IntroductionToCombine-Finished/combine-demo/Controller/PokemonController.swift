//
//  PokemonController.swift
//  combine-demo
//
//  Created by Caleb Meurer on 8/1/22.
//

import UIKit
import Combine


class PokemonController {
    
    private(set) var networkService: Networkable
    private(set) var subscriptions = Set<AnyCancellable>()
    
    @Published var pokemon: [Pokemon] = []
    @Published var pokemonDetails: PokemonDetails?
    @Published var error: NetworkingError?
    
    func getPokemon() {
        let published = networkService.fetchData(from: "https://pokeapi.co/api/v2/pokemon?limit=151&offset=0", for: Results.self)
        published?.sink(receiveCompletion: { completion in
            if case let .failure(error) = completion {
                self.error = error
            }
        }, receiveValue: { decodedData in
            self.pokemon = decodedData.results
        })
        .store(in: &subscriptions)
    }
    
    func getDetails(for pokemon: Pokemon) {
        networkService.fetchData(from: pokemon.url, for: PokemonDetails.self)?.sink(receiveCompletion: { completion in
            if case let .failure(error) = completion {
                self.error = error
            }
        }, receiveValue: { pokemonDetails in
            self.pokemonDetails = pokemonDetails
        })
        .store(in: &subscriptions)
    }
    
    func getSprite(for details: PokemonDetails) -> UIImage? {
        guard let url = URL(string: details.sprites.front_default), let data = try? Data(contentsOf: url) else {
            return nil
        }
        return UIImage(data: data)
    }
    
    init(_ networkService: Networkable) {
        self.networkService = networkService
    }
}
