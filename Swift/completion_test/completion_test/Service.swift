//
//  Service.swift
//  completion_test
//
//  Created by yun on 2023/06/28.
//

import Foundation

func getNews(completion: @escaping (News) -> Void) {
    guard let url = URL(string: "https://api.lil.software/news") else {
        fatalError("URL could not be constructed")
    }

    URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let error = error {
            fatalError("Error retieving quote: \(error.localizedDescription)")
        }
        
        guard let data = data else {
            return
        }
        

        
        do {
            let decoder = JSONDecoder()
            let news = try decoder.decode(News.self, from: data)
            completion(news)
        } catch {
            fatalError("Error decoding data \(error.localizedDescription)")
        }
    }.resume()
}
