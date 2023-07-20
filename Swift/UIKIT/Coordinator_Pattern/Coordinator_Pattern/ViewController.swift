//
//  ViewController.swift
//  Coordinator_Pattern
//
//  Created by yun on 2023/07/16.
//

import UIKit

class ViewController: UIViewController, Storyboarded{
    weak var coordinator: MainCoordinator?
    
    @IBOutlet var product: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func buyTapped(_ sender: Any) {
        coordinator?.buyTapped(to: product.selectedSegmentIndex)
    }
    
    @IBAction func createAccountTapped(_ sender: Any) {
        coordinator?.createAccount()
    }
}

