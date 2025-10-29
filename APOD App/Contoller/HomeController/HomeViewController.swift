//
//  HomeViewController.swift
//  APOD App
//
//  Created by Mohit Vegad on 25/10/2025.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet private weak var _apodDatePicker: UIDatePicker!
    @IBOutlet private weak var _scrollView: UIScrollView!
    @IBOutlet private weak var _stateLabel: UILabel!
    @IBOutlet private weak var _apodImageView: UIImageView!
    @IBOutlet private weak var _apodTitleLabel: UILabel!
    @IBOutlet private weak var _apodDateLabel: UILabel!
    @IBOutlet private weak var _apodDescriptionLabel: UILabel!

    private let viewModel = APODViewModel()

    // --------------------------------------
    // MARK: LIFE CYCLE
    // --------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        _setUpDatePicker()
        _setupBinding()
        viewModel.fetchAPOD()
        _apodDatePicker.addTarget(self, action: #selector(_dateChanged(_:)), for: .editingDidEnd)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // --------------------------------------
    // MARK: PRIVATE
    // --------------------------------------

    private func _setUpDatePicker() {
        _apodDatePicker.maximumDate = Date()
    }

    private func _setupBinding() {
        Loader.shared.showIndicator(on: self.view)

        // SUCCESS
        viewModel.onUpdate = { [weak self] in
            guard let self = self else { return }

            DispatchQueue.main.async {
                Loader.shared.hideIndicator()
                guard let cachedAPOD = self.viewModel.cachedAPOD else {               return
                }

                // APOD available
                self._scrollView.isHidden = false
                self._stateLabel.isHidden = true

                self._apodTitleLabel.text = self.viewModel.titleText
                self._apodDateLabel.text = self.viewModel.dateText
                self._apodDescriptionLabel.text = self.viewModel.explanationText
                if let imageData = self.viewModel.imageData {
                    self._apodImageView.image = UIImage(data: imageData)
                } else {
                    self._apodImageView.image = nil
                }

                if cachedAPOD.isFromCache {
                    print("=== Displaying cached APOD ===")
                    self._stateLabel.isHidden = false
                    self._stateLabel.text = "No APOD available for the selected date."
                }
            }
        }

        // ERROR
        viewModel.onError = { [weak self] message in
            guard let self = self else { return }
            DispatchQueue.main.async {
                Loader.shared.hideIndicator()
                self._scrollView.isHidden = true
                self._stateLabel.text = message
                self._stateLabel.isHidden = false
            }
        }
    }

    // --------------------------------------
    // MARK: EVENT
    // --------------------------------------
    
    @objc private func _dateChanged(_ sender: UIDatePicker) {
        sender.resignFirstResponder()
        Loader.shared.showIndicator(on: self.view)
        viewModel.fetchAPOD(selectedDate: sender.date)
    }
}
