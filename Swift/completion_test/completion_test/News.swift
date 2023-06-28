//
//  News.swift
//  completion_test
//
//  Created by yun on 2023/06/28.
//

import Foundation


struct News: Decodable {
    let articles: [Articles]
}

struct Articles: Decodable {
    let title: String
    let description: String
    let url: String
}
