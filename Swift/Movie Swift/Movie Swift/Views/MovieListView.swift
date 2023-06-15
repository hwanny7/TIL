//
//  MovieListView.swift
//  Movie Swift
//
//  Created by yun on 2023/06/15.
//

import SwiftUI

struct MovieListView: View {
    
    
    @ObservedObject private var nowPlayingState = MovieListState()
    @ObservedObject private var upcomingState = MovieListState()
    @ObservedObject private var topRatedState = MovieListState()
    @ObservedObject private var popularState = MovieListState()

    
    
    
    var body: some View {
        NavigationView {
            List {
                Group {
                    if nowPlayingState.movies != nil {
                        MoviePosterCarousel(title: "Now Playing", movies: nowPlayingState.movies!)
                    } else {
                        LoadingView(isLoading: nowPlayingState.isLoading, error:
                                        nowPlayingState.error) {
                            self.nowPlayingState.loadMovies(with: .nowPlaying)
                        }
                    }
                }

                Group {
                    if upcomingState.movies != nil {
                        MovieBackdropCarousalView(title: "Upcoming", movies: upcomingState.movies!)
                    } else {
                        LoadingView(isLoading: upcomingState.isLoading, error:
                                        upcomingState.error) {
                            self.upcomingState.loadMovies(with: .upcoming)
                        }
                    }
                }
                
                Group {
                    if topRatedState.movies != nil {
                        MovieBackdropCarousalView(title: "Top Rated", movies: topRatedState.movies!)
                    } else {
                        LoadingView(isLoading: topRatedState.isLoading, error:
                                        topRatedState.error) {
                            self.topRatedState.loadMovies(with: .topRated)
                        }
                    }
                }

                Group {
                    if popularState.movies != nil {
                        MovieBackdropCarousalView(title: "Popular", movies: popularState.movies!)
                    } else {
                        LoadingView(isLoading: popularState.isLoading, error:
                                        popularState.error) {
                            self.popularState.loadMovies(with: .popular)
                        }
                    }
                }
            }
            .navigationTitle("The MovieDb")
        }
        .onAppear {
            self.nowPlayingState.loadMovies(with: .nowPlaying)
            self.upcomingState.loadMovies(with: .upcoming)
            self.topRatedState.loadMovies(with: .topRated)
            self.popularState.loadMovies(with: .popular)
        }
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView()
    }
}
