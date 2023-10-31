//
//  MockMovieService.swift
//  FilmHubbTests
//
//  Created by Alphan Ogün on 25.10.2023.
//

import Foundation
@testable import FilmHubb

enum MockAPIError: Error {
    case someError
    case invalidId
    case invalidName
    case invalidList
    
}

class MockMovieService: MovieServicing {
    var isGetMoviesCalled = false
    
    var getMoviesResult: (Result<Movies, Error>)?
    
    func getMovies(for list: String, completion: @escaping (Result<Movies, Error>) -> Void) {
        isGetMoviesCalled = true
      
        if let getMoviesResult {
            completion(getMoviesResult)
        }
    }
    
    var getMovieResult: (Result<FilmHubb.Movie, Error>)?
    var isGetMovieWithIdCalled = false
    
    func getMovie(forId id: Int, completion: @escaping (Result<FilmHubb.Movie, Error>) -> Void) {
        isGetMovieWithIdCalled = true
        
        if let getMovieResult {
            completion(getMovieResult)
        }
    }
    
    var fetchCreditsResult: (Result<FilmHubb.MovieCredits, Error>)?
    var isfetchCreditsCalled = false
    
    func fetchCredits(forId id: Int, completion: @escaping (Result<FilmHubb.MovieCredits, Error>) -> Void) {
        isfetchCreditsCalled = true
        
        if let fetchCreditsResult {
            completion(fetchCreditsResult)
        }
    }
    
    var getVideosResult: (Result<FilmHubb.MovieVideos, Error>)?
    var isGetVideosCalled = false
    
    func getVideos(forId id: Int, completion: @escaping (Result<FilmHubb.MovieVideos, Error>) -> Void) {
        isGetVideosCalled = true
        
        if let getVideosResult {
            completion(getVideosResult)
        }
    }
    
    var searchMovieResult: (Result<FilmHubb.Movies, Error>)?
    var isSearchMovieCalled = false
    
    func searchMovie(withName name: String, completion: @escaping (Result<FilmHubb.Movies, Error>) -> Void) {
        isSearchMovieCalled = true
        
        if let searchMovieResult {
            completion(searchMovieResult)
        }
    }
    
    func fetchCoreData(completion: @escaping (Int, String) -> Void) {
        
    }
    
    func createCoreData(forMovie movie: FilmHubb.Movie, completion: @escaping () -> Void) {
        
    }
    
    func deleteCoreData(forMovie movie: FilmHubb.Movie, completion: @escaping () -> Void) {
        
    }
    
    
}
