//
//  SearchMovieViewModel.swift
//  FilmHubb
//
//  Created by Alphan Ogün on 5.10.2023.
//

import Foundation

class SearchMovieViewModel {
    
    let searchResult: Movie
    
    var posterImage: URL? {
        URL(string: "https://image.tmdb.org/t/p/w500/\(searchResult.posterPath ?? "")")
    }
    
    var titleText: String? {
        searchResult.originalTitle
    }
    
    var nameText: String? {
        searchResult.originalName
    }
    
    //MARK: - Init
    
    init(searchResult: Movie) {
        self.searchResult = searchResult
    }
}
