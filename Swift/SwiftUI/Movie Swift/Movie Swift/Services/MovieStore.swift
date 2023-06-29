//
//  MovieStore.swift
//  Movie Swift
//
//  Created by yun on 2023/06/15.
//

import Foundation


class MovieStore: MovieService {
    // MovieService 프로토콜을 따라서 3 가지 func을 정의한다.
    
    static let shared = MovieStore()
    private init() {}
    
    // private init 메서드를 통해 외부에서는 movieStore의 인스턴스를 직접 생성하지 못하게 함
    // 외부에서는 MovieStore.shared를 통해서만 접근 가능하도록 한다.
    
    // 싱글톤 패턴
    
    private let apiKey = "4e0be2c22f7268edffde97481d49064a"
    private let baseAPIURL = "https://api.themoviedb.org/3"
    private let urlSession = URLSession.shared
    private let jsonDecoder = Utils.jsonDecoder
    
    
    func fetchMovies (from endpoint: MovieListEndpoint, completion: @escaping (Result<MovieResponse, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)/movie/\(endpoint.rawValue)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, completion: completion)
    }
    
    func fetchMovie(id: Int, completion: @escaping (Result<Movie, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)/movie/\(id)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, params: ["append_to_response": "videos, credits"], completion: completion)
    }
    
    func searchMovie(query: String, completion: @escaping (Result<MovieResponse, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseAPIURL)/search/movie") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, params: ["language": "en-US",
                                                 "include_adult" : "false",
                                                 "region" : "US",
                                                 "query": query
                                                ], completion: completion)
    }
    
    private func loadURLAndDecode<D: Decodable>(url: URL, params: [String: String]? = nil, completion: @escaping (Result<D, MovieError>) -> ()) {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        if let params = params {
            queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value)})
        }
        
        urlComponents.queryItems = queryItems
        
        guard let finalURL = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        urlSession.dataTask(with: finalURL) { [weak self](data, response, error ) in
            guard let self = self else {return}
            
            if error != nil {
                self.executeCompletionHandlerInMainThread(with: .failure(.apiError), completion: completion)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                self.executeCompletionHandlerInMainThread(with: .failure(.invalidEndpoint), completion: completion)
                return
            }
            
            guard let data = data else {
                self.executeCompletionHandlerInMainThread(with: .failure(.noData), completion: completion)
                return
            }

            
            do {
                let decodeResponse = try self.jsonDecoder.decode(D.self, from: data)
                print(decodeResponse)
                self.executeCompletionHandlerInMainThread(with: .success(decodeResponse), completion: completion)
            } catch {
                self.executeCompletionHandlerInMainThread(with: .failure(.serializationError), completion: completion)
            }
        }.resume()
    }
    
    private func executeCompletionHandlerInMainThread<D: Decodable>(with result: Result<D, MovieError>, completion: @escaping (Result<D, MovieError>) -> ()) {
        DispatchQueue.main.async {
            completion(result)
        }
        
        // Ui를 업데이트 하기 위해 전달받은 클로저를 main 큐에 넣는다.
        // 해당 클로저는 movieDetailState에 적혀 있고, decoding된 Json을 Movie 객체에 넣는 로직이 적혀있다.
    }
    
}


