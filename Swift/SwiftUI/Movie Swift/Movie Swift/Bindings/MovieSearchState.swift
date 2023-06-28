//
//  MovieSearchState.swift
//  Movie Swift
//
//  Created by yun on 2023/06/28.
//

import SwiftUI
import Combine
import Foundation

class MovieSearchState: ObservableObject {
    
    @Published var query = ""
    @Published var movies: [Movie]?
    @Published var isLoading = false
    @Published var error: NSError?
    
    private var subscriptionToken: AnyCancellable?
    
    let movieService: MovieService
    
    init(movieService: MovieService = MovieStore.shared) {
        self.movieService = movieService
    }
    
    func startObserve() {
        guard subscriptionToken == nil else {return}
        
        self.subscriptionToken = self.$query
            .map {
        
    }
    
    
}
