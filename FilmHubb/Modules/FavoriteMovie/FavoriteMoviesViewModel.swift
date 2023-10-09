//
//  FavoriteMoviesViewModel.swift
//  FilmHubb
//
//  Created by Alphan Ogün on 8.10.2023.
//

import Foundation

class FavoriteMoviesViewModel {
    
    //MARK: - Properties
    
    private let service: MovieService
    
    var ids = [Int]()
    var posterImageUrls = [String]()
    
    //MARK: - Lifecycle
    
    init(service: MovieService = MovieService.shared) {
        self.service = service
        fetchFavoriteMovies {}
    }
    
    //MARK: - Helpers
    
    func fetchFavoriteMovies(completion: @escaping() -> Void)  {
        self.ids = [Int]()
        self.posterImageUrls = [String]()
        
        MovieService.shared.fetchCoreData { id, posterPath in
            self.ids.append(id)
            let fullPosterPath = "https://image.tmdb.org/t/p/w500/" + posterPath
            self.posterImageUrls.append(fullPosterPath)
            completion()
        }
    }
    
    func getMovie(withId id: Int, completion: @escaping(Movie) -> Void) {
        MovieService.shared.fetchMovie(forId: id) { resultForMovie in
            switch resultForMovie {
            case .success(let movieInfo):
                completion(movieInfo)
            case .failure(let error):
                print("DEBUG: Error while fetching movie info, \(error)")
            }
        }
    }
    
    func getCredits(forId id: Int, completion: @escaping(MovieCredits) -> Void) {
        MovieService.shared.fetchCredits(forId: id) { resultForCredits in
            switch resultForCredits {
            case .success(let movieCredits):
                completion(movieCredits)
            case .failure(let error):
                print("DEBUG: Error while fetching movie credits, \(error)")
            }
        }
    }
    
    func getMovieVideos(forId id: Int, completion: @escaping(MovieVideos) -> Void) {
        MovieService.shared.getVideos(forId: id) { resultforMovieVideos in
            switch resultforMovieVideos {
            case .success(let movieVideos):
                completion(movieVideos)
            case .failure(let error):
                print("DEBUG: Error while fetching movie videos, \(error)")
            }
        }
    }
}
