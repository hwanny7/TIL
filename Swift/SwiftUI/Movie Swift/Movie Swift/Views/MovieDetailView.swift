//
//  MovieDetailView.swift
//  Movie Swift
//
//  Created by yun on 2023/06/17.
//

import SwiftUI

struct MovieDetailView: View {
    
    let movieId: Int
    @ObservedObject private var movieDetailState = MovieDetailState()
    
    
    var body: some View {
        ZStack {
            LoadingView(isLoading: self.movieDetailState.isLoading, error: self.movieDetailState.error) {
                self.movieDetailState.loadMovie(id: self.movieId)
            }

            if movieDetailState.movie != nil {
                MovieDetailListView(movie: self.movieDetailState.movie!)
            }
        }
//        .toolbar(.hidden, for: .tabBar)
        .onAppear {self.movieDetailState.loadMovie(id: self.movieId)}
    }
}

struct MovieDetailListView: View {
    let movie: Movie
    @State private var selectedTrailer: MovieVideo?
    
    var body: some View {
        List {
            MovieDetailImage(imageURL: self.movie.backdropURL)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))

            
            
            Group {
                Text(movie.title)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                
                HStack {
                    Text(movie.yearText)
                    Text(movie.durationText)
                    Text(movie.genreText)
                }.frame(maxWidth: .infinity, alignment: .center)
                
                Text(movie.overview)
                
                HStack {
                    if !movie.ratingText.isEmpty {
                        Text(movie.ratingText).foregroundColor(.yellow)
                    }
                    Text(movie.scoreText)
                }
                
                if movie.youtubeTrailers != nil &&
                    movie.youtubeTrailers!.count > 0 {
                    Text("Trailers").font(.headline)
                    
                    ForEach(movie.youtubeTrailers!) { trailer in
                        Button(action: {
                            self.selectedTrailer = trailer
                        }) {
                            HStack {
                                Text(trailer.name)
                                Spacer()
                                Image(systemName: "play.circle.fill")
                                    .foregroundColor(Color(UIColor.systemBlue))
                            }
                        }
                    }
                }
                
            }
            .listRowSeparator(.hidden)


        }
        
        .listStyle(PlainListStyle())
        .sheet(item: self.$selectedTrailer) { trailer in
                SafariView(url: trailer.youtubeURL!)
        }
    }
}

struct MovieDetailImage: View {
    
    @ObservedObject private var imageLoader = ImageLoader()
    let imageURL: URL
    var body: some View {
        ZStack {
            Rectangle().fill(Color.gray.opacity(0.3))
            if self.imageLoader.image != nil {
                Image(uiImage: self.imageLoader.image!)
                    .resizable()
            }
        }
        .aspectRatio(16/9, contentMode: .fit)
        .onAppear {
            self.imageLoader.loadImage(with: self.imageURL)
        }
    }
    
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(movieId: Movie.stubbedMovie.id)
    }
}


