//
//  FavoriteMoviesViewModel.swift
//  FilmHubb
//
//  Created by Alphan Ogün on 8.10.2023.
//

import Foundation

class FavoriteMoviesViewModel {
    
    //MARK: - Properties
    
    private let movieService: MovieServicing
    private let coreDataManager: CoreDataManaging
    
    var ids = [Int]()
    var posterImageUrls = [String]()
    
    //MARK: - Lifecycle
    
    init(movieService: MovieServicing = MovieService(), coreDataManager: CoreDataManaging = CoreDataManager()) {
        self.movieService = movieService
        self.coreDataManager = coreDataManager
        
        fetchFavoriteMovies {}
    }
   
    
    //MARK: - Helpers
    
    func fetchFavoriteMovies(completion: @escaping() -> Void)  {
        self.ids = [Int]()
        self.posterImageUrls = [String]()
        
        coreDataManager.fetchAllCoreData { id, posterPath in
            self.ids.append(id)
            let fullPosterPath = "https://image.tmdb.org/t/p/w500/" + posterPath
            self.posterImageUrls.append(fullPosterPath)
        }
        completion()
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
