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
    var getMoviesResult: Result<Movies, Error>?
    
    func getMovies(for list: String) async throws -> Movies {
        isGetMoviesCalled = true
      
        if let getMoviesResult = getMoviesResult {
            switch getMoviesResult {
            case .success(let movies):
                return movies
            case .failure(let error):
                throw error
            }
        } else {
            throw MockAPIError.someError
        }
    }
    
    var getMovieResult: Result<FilmHubb.Movie, Error>?
    var isGetMovieWithIdCalled = false
    
    func getMovie(forId id: Int) async throws -> Movie{
        isGetMovieWithIdCalled = true
        
        if let getMovieResult = getMovieResult {
            switch getMovieResult {
            case .success(let movie):
                return movie
            case .failure(let error):
                throw error
            }
        } else {
            throw MockAPIError.someError
        }
    }
    
    var fetchCreditsResult: Result<FilmHubb.MovieCredits, Error>?
    var isfetchCreditsCalled = false
    
    func fetchCredits(forId id: Int) async throws -> MovieCredits {
        isfetchCreditsCalled = true
        
        if let fetchCreditsResult = fetchCreditsResult {
            switch fetchCreditsResult {
            case .success(let movieCredits):
                return movieCredits
            case .failure(let error):
                throw error
            }
        } else {
            throw MockAPIError.someError
        }
    }
    
    var getVideosResult: Result<FilmHubb.MovieVideos, Error>?
    var isGetVideosCalled = false
    
    func getVideos(forId id: Int) async throws -> MovieVideos {
        isGetVideosCalled = true
        
        if let getVideosResult = getVideosResult {
            switch getVideosResult {
            case .success(let movieVideos):
                return movieVideos
            case .failure(let error):
                throw error
            }
        } else {
            throw MockAPIError.someError
        }
    }
    
    var searchMovieResult: Result<FilmHubb.Movies, Error>?
    var isSearchMovieCalled = false
    
    func searchMovie(withName name: String) async throws -> Movies {
        isSearchMovieCalled = true
        
        if let searchMovieResult = searchMovieResult {
            switch searchMovieResult {
            case .success(let movies):
                return movies
            case .failure(let error):
                throw error
            }
        } else {
            throw MockAPIError.someError
        }
    }
}
