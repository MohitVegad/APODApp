//
//  Loader.swift
//  APOD App
//
//  Created by Mohit Vegad on 28/10/2025.
//

import UIKit

final class Loader {

    static let shared = Loader()
    private var activityIndicator: UIActivityIndicatorView?

    private init() {}

    // MARK: - Show Loader
    
    func showIndicator(on view: UIView) {
        DispatchQueue.main.async {
            if self.activityIndicator == nil {
                let loader = UIActivityIndicatorView(style: .large)
                loader.translatesAutoresizingMaskIntoConstraints = false
                loader.backgroundColor =  ColorBrand.gray.withAlphaComponent(0.3)
                loader.layer.cornerRadius = 10
                view.addSubview(loader)
                
                NSLayoutConstraint.activate([
                    loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    loader.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                    loader.widthAnchor.constraint(equalToConstant: 80),
                    loader.heightAnchor.constraint(equalToConstant: 80)
                ])
                self.activityIndicator = loader
            }

            self.activityIndicator?.startAnimating()
            self.activityIndicator?.isHidden = false
        }
    }

    func hideIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator?.stopAnimating()
            self.activityIndicator?.isHidden = true
        }
    }
}
