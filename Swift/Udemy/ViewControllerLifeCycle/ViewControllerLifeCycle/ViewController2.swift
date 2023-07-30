//
//  ViewController2.swift
//  ViewControllerLifeCycle
//
//  Created by yun on 2023/07/30.
//

import UIKit

class ViewController2: UIViewController {
    
    @IBOutlet weak var label: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("V2 viewDidLoad")
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("V2 viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("V2 viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("V2 viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("V2 viewDidDisappear")
        
    }
}
