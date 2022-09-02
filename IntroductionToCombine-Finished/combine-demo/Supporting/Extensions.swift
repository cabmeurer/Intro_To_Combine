//
//  Extensions.swift
//  combine-demo
//
//  Created by Caleb Meurer on 8/30/22.
//

import UIKit

extension UIViewController {
    func presentAlert(with error: LocalizedError) {
        DispatchQueue.main.async { [weak self] in
            let alertController = UIAlertController(title: K.errorLoadingData.rawValue, message: error.localizedDescription, preferredStyle: .alert)
            let action = UIAlertAction(title: K.okay.rawValue, style: .default) { [weak self] _ in
                self?.dismiss(animated: true)
            }
            alertController.addAction(action)
            self?.present(alertController, animated: true)
        }
    }
}
