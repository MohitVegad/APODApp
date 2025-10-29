//
//  AlertHelper.swift
//  APOD App
//
//  Created by Mohit Vegad on 28/10/2025.
//

import UIKit

final class AlertHelper {

    static func showAlert(on viewController: UIViewController,
                          title: String = "Alert",
                          message: String,
                          okTitle: String = "Ok",
                          completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: okTitle, style: .default) { _ in
                completion?()
            }
            alert.addAction(okAction)
            viewController.present(alert, animated: true)
        }
    }
}


