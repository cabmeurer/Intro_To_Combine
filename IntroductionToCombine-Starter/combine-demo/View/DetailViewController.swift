//
//  DetailViewController.swift
//  combine-demo
//
//  Created by Caleb Meurer on 8/1/22.
//

import UIKit

class DetailViewController: UIViewController {
    
    private (set)var pokemon: Pokemon?
    private (set)var controller: PokemonController?
    
    private let spinner = UIActivityIndicatorView(style: .large)
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pokedexIDLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startSpinner()
        loadData()
    }
    
    private func layoutView(with details: PokemonDetails) {
        DispatchQueue.main.async { [weak self] in
            self?.nameLabel.text = details.name.capitalized
            self?.nameLabel.isHidden = false
            self?.pokedexIDLabel.text = "Pokedex # \(details.id)"
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
    
    private func loadData() {
        guard let pokemon = pokemon else {
            fatalError("Fatal Error: App is in an unexpected state")
        }
        
        controller?.getDetails(for: pokemon, completion: { [weak self] result in
            switch result {
            case .success(let details):
                self?.layoutView(with: details)
            case .failure(let error):
                self?.presentAlert(with: error)
            }
        })
    }
    
    func setup(_ pokemon: Pokemon, _ controller: PokemonController?) {
        self.pokemon = pokemon
        self.controller = controller
    }
}
