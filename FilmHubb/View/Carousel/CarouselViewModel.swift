//
//  CarouselViewModel.swift
//  FilmHubb
//
//  Created by Alphan Ogün on 2.10.2023.
//

import Foundation

struct CarouselViewModel {
    
    //MARK: - Properties
    
    var movies: [Movie]
    var type: CategoryType
    
    //MARK: - Lifecycle
    
    init(movies: [Movie], type: CategoryType) {
        self.movies = movies
        self.type = type
    }
    
}
