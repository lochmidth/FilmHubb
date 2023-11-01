//
//  HomeViewModel.swift
//  FilmHubb
//
//  Created by Alphan Ogün on 2.10.2023.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func didFetchMovies()
}

enum CategoryType: Int, CaseIterable {
    case nowPlaying
    case upcoming
    case topRated
    case popular
    
    var description: String {
        switch self {
        case .nowPlaying:
            return "Now Playıng"
        case .upcoming:
            return "Upcomıng"
        case .topRated:
            return "Top Rated"
        case .popular:
            return "Popular"
        }
    }
    var listName: String {
        switch self {
        case .nowPlaying:
            return "now_playing"
        case .upcoming:
            return "upcoming"
        case .topRated:
            return "top_rated"
        case .popular:
            return "popular"
        }
    }
}

class HomeViewModel {
    
    //MARK: - Properties
    
    struct Section {
        let title: String
        var movies: [Movie]
        let type: CategoryType
    }
    
    weak var delegate: HomeViewModelDelegate?
    
    var sections = [Section]()
    
    private let movieService: MovieServicing
    
    //MARK: - Lifecycle
    
    init(movieService: MovieServicing = MovieService()) {
        self.movieService = movieService
        sections = CategoryType.allCases.map({ Section(title: $0.description, movies: [], type: $0) })
    }
    
    //MARK: - Helpers
    
    private func updateSection(type: CategoryType, movies: Movies) {
        guard let index = self.sections.firstIndex(where: { $0.type == type }) else { return }
        self.sections[index].movies = movies.results
        self.delegate?.didFetchMovies()
    }
    
    func getMovies(completion: @escaping() -> Void) {
        let types = sections.map({ $0.type })
        types.forEach { type in
            movieService.getMovies(for: type.listName) { [weak self] results in
                switch results {
                case .success(let movies):
                    self?.updateSection(type: type, movies: movies)
                case .failure(let error):
                    print("DEBUG: Error while fetching movie lists, \(error.localizedDescription)")
                }
            }
        }
        completion()
    }
    //FIXME: - refactor this:
    func getAllMovieInfo(forId id: Int, completion: @escaping(Result<(Movie, MovieCredits, MovieVideos), Error>) -> Void) {
        getMovieInfo(id: id) { results in
            completion(results)
        }
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
