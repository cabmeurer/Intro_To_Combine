//
//  PokemonController.swift
//  combine-demo
//
//  Created by Caleb Meurer on 8/1/22.
//

import Foundation
import UIKit

class PokemonController {
    
    private (set)var networkService: Networkable
    
    func getPokemon(completion: @escaping (Result<Results, NetworkingError>) -> Void) {
        networkService.fetchData(from: K.firstGenURL.rawValue, for: Results.self, completion: { result in
            completion(result)
        })
    }
    
    func getDetails(for pokemon: Pokemon, completion: @escaping (Result<PokemonDetails, NetworkingError>) -> Void) {
        networkService.fetchData(from: pokemon.url, for: PokemonDetails.self) { result in
            completion(result)
        }
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
