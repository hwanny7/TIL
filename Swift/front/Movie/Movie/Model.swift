//
//  Model.swift
//  Movie
//
//  Created by yun on 2023/06/14.
//

import Foundation

struct MoviesData: Decodable {
    let movies: [Movie]
    
    private enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}

struct Movie: Decodable {
    let title: String?
    let year: String?
    let rate: String?
    let posterImage: String?
    let overview: String?
    
    private enum Codingkeys: String, CodingKey {
        case title, overview
        case year = "release_date"
        case rate = "vote_average"
        case posterImage = "poster_path"
    }
}

// Json 데이터를 디코딩하여 Swift 객체로 변환시킨다. 데이터의 키 값을 객체의 속성으로 변환시킨다.
