//
//  InspectorViewModel.swift
//  FilmHubb
//
//  Created by Alphan Ogün on 4.10.2023.
//

import UIKit

class InspectorViewModel {
    
    //MARK: - Properties
    
    let movie: Movie
    let movieCredits: MovieCredits
    let movieVideos: MovieVideos
    var movieService: MovieService
    
    var isFavorite = false
    
    var titleText: String? {
        movie.title
    }
    
    var originalTitleText: String? {
        if movie.title == movie.originalTitle {
            return nil
        } else {
            return movie.originalTitle
        }
    }
    
    var releaseDate: String? {
        guard let year = movie.releaseDate?.prefix(4) else { return ""}
        return String(year)
    }
    
    var voteString: String? {
        return String(format: "%.1f", movie.voteAverage)
    }
    
    var infoText: String? {
        "\(movie.genres?[0].name ?? ""), \(movie.genres?[1].name ?? "") ・ \(releaseDate ?? "") ・ \(movie.runtime ?? 0) minutes ・ \(voteString ?? "")/10"
    }
    
    var backdropImageUrl: URL? {
        URL(string: "https://image.tmdb.org/t/p/w500/\(movie.backdropPath ?? "")")
    }
    
    var favoriteStarStatus: UIImage? {
        return isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
    }
    
    var descriptionText: String? {
        movie.overview
    }
    
    var trailerLink: URL? {
        guard let trailer = movieVideos.results.first(where: { $0.type == .trailer && $0.site == .youTube}) else { return nil }
        return URL(string: "https://www.youtube.com/watch?v=\(trailer.key)")
    }
    
    var trailerTitle: String? {
        guard let title = movieVideos.results.first(where: { $0.type == .trailer && $0.site == .youTube }) else { return nil }
        return title.name
    }
    
    var castText: NSMutableAttributedString? {
        if let castArray = movieCredits.cast, !castArray.isEmpty {
            var castNames: [String] = []
            
            for index in 0..<min(8, castArray.count) {
                let castMember = castArray[index]
                let castName = castMember.name
                castNames.append(castName)
            }
            let attributedString = NSMutableAttributedString()
            
            appendNamesToAttributedString(attributedString, title: "Starring(s)", names: castNames, count: 8)
            
            return attributedString
        } else {
            return NSMutableAttributedString(string: "No cast information available")
        }
    }
    
    var crewText: NSMutableAttributedString? {
        if let crewArray = movieCredits.crew, !crewArray.isEmpty {
            
            let allCrewAttributedString = NSMutableAttributedString()
            
            var directorNames: [String] = []
            var editorNames: [String] = []
            var producerNames: [String] = []
            
            for crewMember in crewArray {
                let name = crewMember.name
                if let department = crewMember.department {
                    switch department {
                    case .directing:
                        directorNames.append(name)
                    case .editing:
                        editorNames.append(name)
                    case .production:
                        producerNames.append(name)
                    default:
                        break
                    }
                }
            }
            
            appendNamesToAttributedString(allCrewAttributedString, title: "Director(s)", names: directorNames, count: 2)
            appendNamesToAttributedString(allCrewAttributedString, title: "\nEditor(s)", names: editorNames, count: 2)
            appendNamesToAttributedString(allCrewAttributedString, title: "\nProducer(s)", names: producerNames, count: 2)
            
            return allCrewAttributedString
        } else {
            return NSMutableAttributedString(string: "No crew information available")
        }
    }
    
    
    
    //MARK: - Lifecycle
    
    init(movieService: MovieService, movie: Movie, movieCredits: MovieCredits, movieVideos: MovieVideos) {
        self.movieService = movieService
        self.movie = movie
        self.movieCredits = movieCredits
        self.movieVideos = movieVideos
        
        fetchCoreDataForCurrentMovie()
    }
    
    //MARK: - Helpers
    
    func calculateFontSize(for title: String, _ containerView: UIView) -> CGFloat {
        let maxWidth = containerView.frame.width - 60
        let titleSize = title.size(withAttributes: [.font: UIFont.boldSystemFont(ofSize: 24)])
        
        let fontScaleFactor = min(maxWidth / titleSize.width, 1.0)
        let dynamicFontSize = 24 * fontScaleFactor
        
        return dynamicFontSize
    }
    
    
    func appendNamesToAttributedString(_ attributedString: NSMutableAttributedString, title: String, names: [String], count: Int) {
        if !names.isEmpty {
            let titleText = NSAttributedString(string: "\(title)", attributes: [
                .font: UIFont.boldSystemFont(ofSize: 16)
            ])
            attributedString.append(titleText)
            
            for (index, name) in names.prefix(count).enumerated() {
                if index < count {
                    attributedString.append(NSAttributedString(string: "\n\(name)"))
                }
            }
        }
    }
    
    func createCoreData(forMovie movie: Movie, completion: @escaping() -> Void) {
        movieService.createCoreData(forMovie: movie, completion: completion)
    }
    
    func fetchCoreDataForCurrentMovie() {
        movieService.fetchCoreData(forMovie: movie) { id, posterImageUrl in
            if id == self.movie.id {
                self.isFavorite = true
            } else {
                self.isFavorite = false
            }
        }
    }
}
