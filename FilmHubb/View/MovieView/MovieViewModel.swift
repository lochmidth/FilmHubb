//
//  MovieViewModel.swift
//  FilmHubb
//
//  Created by Alphan Ogün on 2.10.2023.
//

import Foundation

class MovieViewModel {
    
    let movie: Movie?
    var posterImageUrl = ""
    
    var posterImage: URL? {
        if movie != nil {
            return URL(string: "https://image.tmdb.org/t/p/w500/\(movie?.posterPath ?? "")")
        } else {
            return URL(string: "https://image.tmdb.org/t/p/w500/\(posterImageUrl)")
        }
    }
    
    init(movie: Movie? = nil, posterImageUrl: String? = nil ) {
        self.movie = movie
        
        if let url = posterImageUrl {
            self.posterImageUrl = url
        }
    }
}
