//
//  MockHomeViewModelDelegate.swift
//  FilmHubbTests
//
//  Created by Alphan Ogün on 27.10.2023.
//

import Foundation
@testable import FilmHubb

class MockHomeViewModelDelegate: HomeViewModelDelegate {
    
    var isDidFetchMoviesCalled = false
    
    func didFetchMovies() {
        isDidFetchMoviesCalled = true
    }
}
