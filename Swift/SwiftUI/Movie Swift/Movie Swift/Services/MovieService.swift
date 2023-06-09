//
//  MovieService.swift
//  Movie Swift
//
//  Created by yun on 2023/06/15.
//

import Foundation


protocol MovieService {
    
    func fetchMovies (from endpoint: MovieListEndpoint, completion: @escaping (Result<MovieResponse, MovieError>) -> ())
    
    func fetchMovie(id: Int, completion: @escaping (Result<Movie, MovieError>) -> ())
    
    func searchMovie(query: String, completion: @escaping (Result<MovieResponse, MovieError>) -> ())
    
}

enum MovieListEndpoint: String, CaseIterable {
    case nowPlaying = "now_playing"
    case upcoming
    case topRated = "top_rated"
    case popular
    
    var description: String {
        switch self {
        case .nowPlaying: return "Now Playing"
        case .upcoming: return "Upcoming"
        case .topRated: return "Top Rated"
        case .popular: return "Popular"
        }
    }
}

// url end point 를 반환


enum MovieError: Error, CustomNSError {
    
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
    
    var localizedDescription: String {
        switch self {
        case .apiError: return "Failed to fetch data"
        case .invalidEndpoint: return "Invalid endpoint"
        case .invalidResponse: return "invalid response"
        case .noData: return "No data"
        case .serializationError: return "Failed to decode data"
        }
    }
    var errorUserInfo: [String : Any] {
        [NSLocalizedDescriptionKey : localizedDescription]
    }
}


