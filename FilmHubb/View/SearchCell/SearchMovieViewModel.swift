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
        searchResult.title
    }
    
    var originalTitleText: String? {
        if searchResult.title == searchResult.originalTitle {
            return nil
        } else {
            return searchResult.originalTitle
        }
    }
    
    //MARK: - Init
    
    init(searchResult: Movie) {
        self.searchResult = searchResult
    }
}
