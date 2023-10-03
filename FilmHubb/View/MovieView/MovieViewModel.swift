//
//  MovieViewModel.swift
//  FilmHubb
//
//  Created by Alphan Ogün on 2.10.2023.
//

import Foundation

class MovieViewModel {
    
    let movie: Movie
    
    var posterImage: URL? {
        return URL(string: "https://image.tmdb.org/t/p/w500/\(movie.posterPath ?? "")")
    }
    
    init(movie: Movie) {
        self.movie = movie
    }
}
