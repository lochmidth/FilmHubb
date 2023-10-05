//
//  SearchViewModel.swift
//  FilmHubb
//
//  Created by Alphan Ogün on 5.10.2023.
//

import Foundation

class SearchViewModel {
    
    var movies = [Movie]()
    
    func searchMovie(withName name: String, completion: @escaping() -> Void) {
        MovieService.shared.searchMovie(withName: name) { results in
            switch results {
            case .success(let movies):
                self.movies = movies
                completion()
            case .failure(let error):
                print("DEBUG: Error while searching for movies, \(error)")
            }
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
