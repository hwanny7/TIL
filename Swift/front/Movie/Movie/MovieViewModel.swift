//
//  MovieViewModel.swift
//  Movie
//
//  Created by yun on 2023/06/14.
//

import Foundation

class MovieViewModel {
    
    private var apiService = ApiService()
    private var popularMovies = [Movie]()
    
    func fetchPopularMoviesData(completion: () -> ()) {
        
        apiService.getPopularMoviesData { [weak self] (result) in
            
            switch result {
            case .success(let listOf):
                self?.popularMovies = listOf.movies
                completion()
            case .failure(let error):
                print("Error processing json data: \(error)")
            }
        }
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        if popularMovies.count != 0 {
            return popularMovies.count
        }
        return 0
    }
    
    func cellForRowAt (indexPath: IndexPath) -> Movie {
        return popularMovies[indexPath.row]
    }
}
