//
//  SceneDelegate.swift
//  combine-demo
//
//  Created by Caleb Meurer on 7/19/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else { return }
        
        let networkService = NetworkService()
        let controller = PokemonController(networkService)
        viewController.setup(controller)
        
        let navigationController = UINavigationController(rootViewController: viewController)
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

