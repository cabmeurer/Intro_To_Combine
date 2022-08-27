//
//  MainViewController.swift
//  combine-demo
//
//  Created by Caleb Meurer on 7/19/22.
//

import UIKit
import Combine

class MainViewController: UIViewController {
    
    private(set) var controller: PokemonController?
    private(set) var pokemon: [Pokemon] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var cancellable: AnyCancellable?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Pokedex"
        tableView.delegate = self
        tableView.dataSource = self
        
        handleErrors()
        loadData()
    }
    
    private func handleErrors() {
        self.cancellable = controller?.$error.sink(receiveValue: { error in
            guard let error = error else { return }
            self.presentAlert(with: error)
        })
    }
    
    private func loadData() {
        self.cancellable = controller?.$pokemon.sink(receiveValue: { self.pokemon = $0 })
        controller?.getPokemon()
    }
    
    func setup(_ controller: PokemonController) {
        self.controller = controller
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Pokemon") else {
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
        guard let viewController = UIStoryboard(name: "Detail", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController, let row = tableView.indexPathForSelectedRow?.row else { return }
        viewController.setup(pokemon[row], controller)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension UIViewController {
    func presentAlert(with error: LocalizedError) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error loading data", message: error.localizedDescription, preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .default) { _ in
                self.dismiss(animated: true)
            }
            alertController.addAction(action)
            self.present(alertController, animated: true)
        }
    }
}
