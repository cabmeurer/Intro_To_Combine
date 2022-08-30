//
//  MainViewController.swift
//  combine-demo
//
//  Created by Caleb Meurer on 7/19/22.
//

import UIKit

class MainViewController: UIViewController {
    
    private (set)var controller: PokemonController?
    private (set)var pokemon: [Pokemon] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = K.pokedex.rawValue
        
        tableView.delegate = self
        tableView.dataSource = self
        loadData()
    }
    
    private func loadData() {
        controller?.getPokemon(completion: { [weak self] result in
            switch result {
            case .success(let decodedData):
                self?.pokemon = decodedData.results
            case .failure(let error):
                self?.presentAlert(with: error)
            }
        })
    }
    
    func setup(_ controller: PokemonController) {
        self.controller = controller
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.pokemon.rawValue) else {
            fatalError("Fatal Error: App is in an unexpected State")
        }
        
        cell.textLabel?.text = pokemon[indexPath.row].name.capitalized
        cell.textLabel?.font = .systemFont(ofSize: 22)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemon.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = UIStoryboard(name: K.detail.rawValue, bundle: nil).instantiateViewController(withIdentifier: K.detailViewController.rawValue) as? DetailViewController, let row = tableView.indexPathForSelectedRow?.row else { return }
        viewController.setup(pokemon[row], controller)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
