//
//  ContentView.swift
//  completion_test
//
//  Created by yun on 2023/06/28.
//

import SwiftUI

struct ContentView: View {
    @State private var news: News?
    
    var body: some View {
        NavigationView {
            VStack {
                Button("뉴스를 받아보자!") {
                    getNews(completion: changeNewsData)
                }
            }
        }
    }

    func changeNewsData(news: News) {
        self.news = news
    }
    
}


struct NewsView: View {
    let title: String
    let description: String
    let url: String
    
    var body: some View {
        VStack {
            Text(title).font(.headline)
            Text(description).fontWeight(.bold)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
