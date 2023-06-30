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
    
    // Combine 프레임워크에서 제공하는 프로토콜
    // 비동기 작업의 구독을 취소하는 데 사용되는 객체
    
    let movieService: MovieService
    
    init(movieService: MovieService = MovieStore.shared) {
        self.movieService = movieService
    }
    
    func startObserve() {
        guard subscriptionToken == nil else {return}
        // startObserve 가 여러번 호출될수도 있기 때문에 중복 구독을 방지하기 위함
        
        self.subscriptionToken = self.$query
            .map { [weak self] text in
                self?.movies = nil
                self?.error = nil
                return text
                
            }.throttle(for: 1, scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] in self?.search(query: $0)}
        
        // throttle 은 1초 동안 입력이 없을 때 가장 최근 값으로 검색 요청
        // sink는 최종적으로 처리하는데, 최종 쿼리 값 Text가 전달된다.
        
        
    }
    
    func search(query: String) {

        self.movies = nil
        self.isLoading = false
        self.error = nil
        
        guard !query.isEmpty else {
            return
        }
        
        
        self.isLoading = true
        
        // 한 번 밖에 작동 안 함. Mainqueue에 넣어서 ui를 변경해야 하는가?
        
        
        self.movieService.searchMovie(query: query) {[weak self] (result) in
            guard let self = self, self.query == query else { return }
            
            self.isLoading = false
            switch result {
            case .success(let response):
                self.movies = response.results
            case .failure(let error):
                self.error = error as NSError
            }
            
        }
    }
    
    deinit {
        self.subscriptionToken?.cancel()
        self.subscriptionToken = nil
    }
    
}
