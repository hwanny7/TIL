//
//  MovieDetailState.swift
//  Movie Swift
//
//  Created by yun on 2023/06/17.
//

import SwiftUI


class MovieDetailState: ObservableObject {
    
    private let movieService: MovieService
    @Published var movie: Movie?
    @Published var isLoading = false
    @Published var error: NSError?
    
    init(movieService: MovieService = MovieStore.shared) {
        self.movieService = movieService
        
    }
    
    func loadMovie(id: Int) {
        self.movie = nil
        self.isLoading = true
        self.movieService.fetchMovie(id: id) {[weak self] (result) in
            guard let self = self else {return}
            
            self.isLoading = false
            switch result {
            case .success(let movie):
                self.movie = movie
            case .failure(let error):
                self.error = error as NSError
            }
            
        }
        // {} 부분은 클로저이고 메서드의 두 번째 인자로 전달된다.
        // 클로저는 비동기적으로 실행되며, 메서드의 API 요청이 완료된 후 호출된다.
    }
    
}


