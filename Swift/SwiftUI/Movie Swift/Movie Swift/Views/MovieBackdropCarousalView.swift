//
//  MovieBackdropCarousalView.swift
//  Movie Swift
//
//  Created by yun on 2023/06/15.
//

import SwiftUI

struct MovieBackdropCarousalView: View {
    
    let title: String
    let movies: [Movie]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 16) {
                    ForEach(self.movies) { movie in
                        NavigationLink(destination: MovieDetailView(movieId: movie.id)) {
                            MovieBackdropCard(movie: movie)
                                .frame(width: 272, height: 200)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.leading, movie.id == self.movies.first!.id ? 16: 0)
                        .padding(.trailing, movie.id == self.movies.last!.id ? 16: 0)
                    }
                }
            }
            
        }
    }
}

struct MovieBackdropCarousalView_Previews: PreviewProvider {
    static var previews: some View {
        MovieBackdropCarousalView(title: "Latest", movies: Movie.stubbedMovies)
    }
}
