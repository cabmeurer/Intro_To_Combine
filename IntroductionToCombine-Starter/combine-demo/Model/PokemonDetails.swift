//
//  PokemonDetails.swift
//  combine-demo
//
//  Created by Caleb Meurer on 8/2/22.
//

import Foundation

struct PokemonDetails: Codable {
    
    var id: Int
    var name: String
    var sprites: Sprites
    
    init(id: Int, name: String, sprites: Sprites) {
        self.id = id
        self.name = name
        self.sprites = sprites
    }
}
