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
    
    func getMovies() async throws {
        let types = sections.map({ $0.type })
        for type in types {
            do {
                let movies = try await movieService.getMovies(for: type.listName)
                self.updateSection(type: type, movies: movies)
            } catch {
                throw error
            }
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
