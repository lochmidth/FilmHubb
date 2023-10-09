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

//MARK: - Movie
struct Movie: Codable {
    let id: Int
    let mediaType: String?
    let genres: [Genre]?
    let runtime: Int?
    let originalName: String?
    let title: String?
    let originalTitle: String?
    let posterPath: String?
    let backdropPath: String?
    let overview: String?
    let releaseDate: String?
    let voteAverage: Double
}

// MARK: - Genre
struct Genre: Codable {
    let id: Int
    let name: String?
}

// MARK: - MovieCredits
struct MovieCredits: Codable {
    let id: Int
    let cast, crew: [Cast]?
}

// MARK: - Cast
struct Cast: Codable {
    let adult: Bool
    let gender, id: Int
    let name, originalName: String
    let popularity: Double
    let profilePath: String?
    let castId: Int?
    let character: String?
    let creditId: String
    let order: Int?
    let department: Department?
    let job: String?
}

enum Department: String, Codable {
    case acting = "Acting"
    case art = "Art"
    case camera = "Camera"
    case costumeMakeUp = "Costume & Make-Up"
    case creator = "Creator"
    case crew = "Crew"
    case directing = "Directing"
    case editing = "Editing"
    case lighting = "Lighting"
    case production = "Production"
    case sound = "Sound"
    case visualEffects = "Visual Effects"
    case writing = "Writing"
}

// MARK: - MovieVideos
struct MovieVideos: Codable {
    let id: Int
    let results: [Videos]
}

// MARK: - Result
struct Videos: Codable {
    let name, key: String
    let site: Site
    let size: Int
    let type: TypeEnum
    let official: Bool
    let publishedAt, id: String
}

enum Site: String, Codable {
    case youTube = "YouTube"
}

enum TypeEnum: String, Codable {
    case behindTheScenes = "Behind the Scenes"
    case clip = "Clip"
    case featurette = "Featurette"
    case teaser = "Teaser"
    case trailer = "Trailer"
}

