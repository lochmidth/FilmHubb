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
                self.movies = movies.results
                completion()
            case .failure(let error):
                print("DEBUG: Error while searching for movies, \(error)")
                completion()
            }
        }
    }
    
    //FIXME: - refactor this:
    func getAllMovieInfo(forId id: Int, completion: @escaping(Result<(Movie, MovieCredits, MovieVideos), Error>) -> Void) {
        getMovieInfo(id: id) { results in
            completion(results)
        }
        
//        getMovie(withId: id) { movieResults in
//            switch movieResults {
//            case .success(let movie):
//                self.getCredits(forId: id) { creditResults in
//                    switch creditResults {
//                    case .success(let movieCredit):
//                        self.getMovieVideos(forId: id) { videoResults in
//                            switch videoResults {
//                            case .success(let movieVideos):
//                                completion(.success((movie, movieCredit, movieVideos)))
//                            case .failure(let error):
//                                completion(.failure(error))
//                            }
//                        }
//                    case .failure(let error):
//                        completion(.failure(error))
//                    }
//                }
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
    }
    
    private func getMovieInfo(id: Int, completion: @escaping(Result<(Movie, MovieCredits, MovieVideos), Error>) -> Void) {
        var movieInfo: (Movie?, MovieCredits?, MovieVideos?) = (nil, nil, nil)
        var error: Error?
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        getMovie(withId: id) { results in
            switch results {
            case .success(let movie):
                movieInfo.0 = movie
            case .failure(let err):
                error = err
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        getCredits(forId: id) { results in
            switch results {
            case .success(let movieCredit):
                movieInfo.1 = movieCredit
            case .failure(let err):
                error = err
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        getMovieVideos(forId: id) { results in
            switch results {
            case .success(let movieVideos):
                movieInfo.2 = movieVideos
            case .failure(let err):
                error = err
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            if let error = error {
                completion(.failure(error))
            } else if let movie = movieInfo.0, let credits = movieInfo.1, let videos = movieInfo.2 {
                completion(.success((movie, credits, videos)))
            }
        }
    }
    
    func getMovie(withId id: Int, completion: @escaping(Result<Movie, Error>) -> Void) {
        movieService.getMovie(forId: id) { resultForMovie in
            switch resultForMovie {
            case .success(let movieInfo):
                completion(.success(movieInfo))
            case .failure(let error):
                print("DEBUG: Error while fetching movie info, \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func getCredits(forId id: Int, completion: @escaping(Result<MovieCredits, Error>) -> Void) {
        movieService.fetchCredits(forId: id) { resultForCredits in
            switch resultForCredits {
            case .success(let movieCredits):
                completion(.success(movieCredits))
            case .failure(let error):
                print("DEBUG: Error while fetching movie credits, \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func getMovieVideos(forId id: Int, completion: @escaping(Result<MovieVideos, Error>) -> Void) {
        movieService.getVideos(forId: id) { resultforMovieVideos in
            switch resultforMovieVideos {
            case .success(let movieVideos):
                completion(.success(movieVideos))
            case .failure(let error):
                print("DEBUG: Error while fetching movie videos, \(error)")
                completion(.failure(error))
            }
        }
    }
}
