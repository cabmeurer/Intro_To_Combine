//
//  Extensions.swift
//  combine-demo
//
//  Created by Caleb Meurer on 8/30/22.
//

import UIKit

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
