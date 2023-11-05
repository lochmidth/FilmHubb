//
//  SearchViewModel.swift
//  FilmHubb
//
//  Created by Alphan Ogün on 5.10.2023.
//

import Foundation

class SearchViewModel {
    
    var movies = [Movie]()
    
    private let movieService: MovieServicing
    
    init(movieService: MovieServicing = MovieService()) {
        self.movieService = movieService
    }
        
    func searchMovie(withName name: String) async throws {
        do {
            let searchedMovies = try await movieService.searchMovie(withName: name)
            self.movies = searchedMovies.results
        } catch {
            throw error
        }
    }
    
    func getAllMovieInfo(for id: Int) async throws -> (Movie, MovieCredits, MovieVideos) {
        do {
            let movie = try await getMovie(withId: id)
            let movieCredits = try await getCredits(forId: id)
            let movieVideos = try await getMovieVideos(forId: id)
            return (movie, movieCredits, movieVideos)
        } catch {
            throw error
        }
    }
    
    func getMovie(withId id: Int) async throws -> Movie {
        do {
            return try await movieService.getMovie(forId: id)
        } catch {
            throw error
        }
    }
    
    func getCredits(forId id: Int) async throws -> MovieCredits {
        do {
            return try await movieService.fetchCredits(forId: id)
        } catch {
            throw error
        }
    }
    
    func getMovieVideos(forId id: Int) async throws -> MovieVideos {
        do {
            return try await movieService.getVideos(forId: id)
        } catch {
            throw error
        }
    }
}
