//
//  Sprites.swift
//  combine-demo
//
//  Created by Caleb Meurer on 8/2/22.
//

import Foundation

struct Sprites: Codable {

    var front_default: String
    
    internal init(front_default: String) {
        self.front_default = front_default
    }
}
