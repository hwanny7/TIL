//
//  ViewController.swift
//  Movie
//
//  Created by yun on 2023/06/14.
//

import UIKit

class ViewController: UIViewController {

    var apiService = ApiService()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiService.getPopularMoviesData {(result) in
            print(result)
        }
    }


}

