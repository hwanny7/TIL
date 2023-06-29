//
//  News.swift
//  completion_test
//
//  Created by yun on 2023/06/28.
//

import Foundation


struct News: Decodable {
    let articles: [Article]
}

struct Article: Decodable {
    let title: String
    let url: String
    let description: String?
}

