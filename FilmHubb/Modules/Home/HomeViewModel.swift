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
    
    //MARK: - Lifecycle
    
    init() {
        sections = CategoryType.allCases.map({ Section(title: $0.description, movies: [], type: $0) })
    }
    
    //MARK: - Helpers
    
    func updateSection(type: CategoryType, movies: [Movie]) {
        guard let index = self.sections.firstIndex(where: { $0.type == type }) else { return }
        self.sections[index].movies = movies
        self.delegate?.didFetchMovies()
    }
    
    func getMovies() {
        let types = sections.map({ $0.type })
        types.forEach { type in
            MovieService.shared.getMovies(for: type.listName) { results in
                switch results {
                case .success(let movies):
                    self.updateSection(type: type, movies: movies)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
