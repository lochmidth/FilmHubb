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
    
    func searchMovie(withName name: String, completion: @escaping() -> Void) {
        movieService.searchMovie(withName: name) { results in
            switch results {
            case .success(let movies):
                self.movies = movies
                completion()
            case .failure(let error):
                print("DEBUG: Error while searching for movies, \(error)")
            }
        }
    }
    
    func getAllMovieInfo(forId id: Int, completion: @escaping(Movie, MovieCredits, MovieVideos) -> Void) {
        getMovie(withId: id) { movie in
            self.getCredits(forId: id) { movieCredits in
                self.getMovieVideos(forId: id) { movieVideos in
                    completion(movie, movieCredits, movieVideos)
                }
            }
        }
    }
    
    func getMovie(withId id: Int, completion: @escaping(Movie) -> Void) {
        movieService.fetchMovie(forId: id) { resultForMovie in
            switch resultForMovie {
            case .success(let movieInfo):
                completion(movieInfo)
            case .failure(let error):
                print("DEBUG: Error while fetching movie info, \(error)")
            }
        }
    }
    
    func getCredits(forId id: Int, completion: @escaping(MovieCredits) -> Void) {
        movieService.fetchCredits(forId: id) { resultForCredits in
            switch resultForCredits {
            case .success(let movieCredits):
                completion(movieCredits)
            case .failure(let error):
                print("DEBUG: Error while fetching movie credits, \(error)")
            }
        }
    }
    
    func getMovieVideos(forId id: Int, completion: @escaping(MovieVideos) -> Void) {
        movieService.getVideos(forId: id) { resultforMovieVideos in
            switch resultforMovieVideos {
            case .success(let movieVideos):
                completion(movieVideos)
            case .failure(let error):
                print("DEBUG: Error while fetching movie videos, \(error)")
            }
        }
    }
}
