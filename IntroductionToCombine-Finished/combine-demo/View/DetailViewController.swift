//
//  DetailViewController.swift
//  combine-demo
//
//  Created by Caleb Meurer on 8/1/22.
//

import UIKit
import Combine

class DetailViewController: UIViewController {
    
    private(set) var pokemon: Pokemon?
    private(set) var controller: PokemonController?
    
    private(set) var cancellable = Set<AnyCancellable>()
    
    private let spinner = UIActivityIndicatorView(style: .large)
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pokedexIDLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startSpinner()
        handleErrors()
        loadData()
    }
    
    private func layoutView(with details: PokemonDetails) {
        DispatchQueue.main.async { [weak self] in
            self?.nameLabel.text = details.name.capitalized
            self?.nameLabel.isHidden = false
            self?.pokedexIDLabel.text = "\(K.pokedex.rawValue) # \(details.id)"
            self?.pokedexIDLabel.isHidden = false
            self?.imageView.image = self?.controller?.getSprite(for: details)
            self?.imageView.isHidden = false
            self?.spinner.stopAnimating()
        }
    }
    
    private func startSpinner() {
        view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        spinner.startAnimating()
    }
    
    private func handleErrors() {
        controller?.$error.sink(receiveValue: { [weak self] error in
            guard let error = error else { return }
            self?.presentAlert(with: error)
        }).store(in: &cancellable)
    }
    
    private func loadData() {
        guard let pokemon = pokemon else {
            fatalError("Fatal Error: App is in an unexpected state")
        }
        
        controller?.$pokemonDetails.sink(receiveValue: { [weak self] details in
            guard let details = details else { return }
            self?.layoutView(with: details)
        }).store(in: &cancellable)
        controller?.getDetails(for: pokemon)
    }
    
    func setup(_ pokemon: Pokemon, _ controller: PokemonController?) {
        self.pokemon = pokemon
        self.controller = controller
    }
}
