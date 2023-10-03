//
//  Movie.swift
//  FilmHubb
//
//  Created by Alphan Ogün on 2.10.2023.
//

import Foundation

struct MoviesResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let id: Int
    let mediaType: String?
    let originalName: String?
    let originalTitle: String?
    let posterPath: String?
    let overview: String?
    let voteCount: Int
    let releaseDate: String?
    let voteAverage: Double
}
