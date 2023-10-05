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
    
    var titleText: String? {
        movie.originalTitle
    }
    
    var releaseDate: String? {
        guard let year = movie.releaseDate?.prefix(4) else { return ""}
        return String(year)
    }
    
    var voteString: String? {
        return String(format: "%.1f", movie.voteAverage)
    }
    
    var infoText: String? {
        "\(movie.genres?.first?.name ?? "") ・ \(releaseDate ?? "") ・ \(movie.runtime ?? 0) minutes ・ \(voteString ?? "")/10"
    }
    
    var backdropImageUrl: URL? {
        URL(string: "https://image.tmdb.org/t/p/w500/\(movie.backdropPath ?? "")")
    }
    
    var descriptionText: String? {
        movie.overview
    }
    
    var youtubeLink: URL? {
        guard let trailer = movieVideos.results.first(where: { $0.type == .trailer && $0.site == .youTube}) else { return nil }
            return URL(string: "https://www.youtube.com/watch?v=\(trailer.key)")
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
    
    init(movie: Movie, movieCredits: MovieCredits, movieVideos: MovieVideos) {
        self.movie = movie
        self.movieCredits = movieCredits
        self.movieVideos = movieVideos
    }
    
    //MARK: - Helpers
    
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
}
