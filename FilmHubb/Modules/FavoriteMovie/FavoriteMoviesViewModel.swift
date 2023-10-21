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
    
    var ids = [Int]()
    var posterImageUrls = [String]()
    
    //MARK: - Lifecycle
    
    init(movieService: MovieServicing = MovieService()) {
        self.movieService = movieService
        fetchFavoriteMovies {}
    }
   
    
    //MARK: - Helpers
    
    func fetchFavoriteMovies(completion: @escaping() -> Void)  {
        self.ids = [Int]()
        self.posterImageUrls = [String]()
        
        movieService.fetchCoreData { id, posterPath in
            self.ids.append(id)
            let fullPosterPath = "https://image.tmdb.org/t/p/w500/" + posterPath
            self.posterImageUrls.append(fullPosterPath)
            completion()
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
