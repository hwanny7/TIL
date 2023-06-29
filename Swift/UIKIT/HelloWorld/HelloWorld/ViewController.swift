//
//  ViewController.swift
//  HelloWorld
//
//  Created by yun on 2023/06/29.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func clickButton(_ sender: Any) {
        self.label.text! += "클릭~~"
    }

}

