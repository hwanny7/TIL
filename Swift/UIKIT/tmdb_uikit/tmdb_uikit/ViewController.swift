//
//  ViewController.swift
//  tmdb_uikit
//
//  Created by yun on 2023/06/26.
//

import UIKit

class ViewController: UIViewController {
    
    var apiService = ApiService()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        apiService.getPopularMoviesData{ (result) in
            print(result)
        }
    }


}

