//
//  Constants.swift
//  combine-demo
//
//  Created by Caleb Meurer on 8/30/22.
//

import Foundation

enum K: String {
    case pokemon = "Pokemon"
    case pokedex = "Pokedex"
    
    case firstGenURL = "https://pokeapi.co/api/v2/pokemon?limit=151&offset=0"
    
    case main = "Main"
    case mainViewController = "MainViewController"
    case detail = "Detail"
    case detailViewController = "DetailViewController"
    
    case errorLoadingData = "Error loading data"
    case invalidURL = "The url is not valid, unable to connect to server"
    
    case okay = "Okay"
}
