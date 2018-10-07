//
//  ViewController.swift
//  testing_the_waters_of_ios
//
//  Created by Kostas Kremizas on 23/09/2018.
//  Copyright © 2018 kremizas. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var label: UILabel!
    
    
    var viewModel: ViewModelProtocol!
    
    func configure(_ viewModel: ViewModelProtocol) {
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.isLoading { [weak self] (isLoading) in
            // Already in main queue
            if isLoading {
                self?.activityIndicator.startAnimating()
            } else {
                self?.activityIndicator.stopAnimating()
            }
        }
        
        viewModel.isButtonEnabled { [weak self] (isEnabled) in
            // Already in main queue
            self?.calculateButton.isEnabled = isEnabled
        }
        
        viewModel.labelText { [weak self] (text) in
            self?.label.text = text
        }
    }
    
    @IBAction func calculateButtonTapped(_ sender: Any) {
        viewModel.calculateButtonTapped()
    }
}

