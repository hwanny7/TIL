//
//  ContentView.swift
//  Movie Swift
//
//  Created by yun on 2023/06/14.
//

import SwiftUI

struct ContentView: View {
    init() {
        UINavigationBar.appearance().backgroundColor = .orange
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = UIColor.orange
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        navBarAppearance.shadowColor = .clear
    }
    
    
    var body: some View {
        NavigationView {
            TabView {
                MovieListView()
                    .tabItem {
                        VStack {
                            Image(systemName: "tv")
                            Text("Movies")
                        }
                    }
                    .tag(0)
                
                MovieSearchView()
                    .tabItem {
                        VStack {
                            Image(systemName: "magnifyingglass")
                            Text("Search")
                        }
                    }
                    .tag(1)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
