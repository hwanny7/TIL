//
//  ViewController.swift
//  interface_builder_test
//
//  Created by yun on 2023/07/01.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var labelTitle: UILabel!
    
    @IBOutlet var uiTitle01: UILabel!
    
    @IBOutlet var uiTitle02: UILabel!
    @IBOutlet var uiTitle03: UILabel!
    @IBOutlet var uiTitle04: UILabel!
    @IBOutlet var uiTitle05: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func clickButton(_ sender: Any) {
        self.uiTitle01.text = "clicked"
    }
    @IBAction func clickButton2(_ sender: Any) {
        self.uiTitle02.text = "clicked"
    }
    @IBAction func clickButton3(_ sender: Any) {
        self.uiTitle03.text = "clicked"
    }
    @IBAction func clickButton4(_ sender: Any) {
    }
    @IBAction func clickButton5(_ sender: Any) {
    }
    
}

