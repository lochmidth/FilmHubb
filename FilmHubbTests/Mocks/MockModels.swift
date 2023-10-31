//
//  MockMovies.swift
//  FilmHubbTests
//
//  Created by Alphan Ogün on 26.10.2023.
//

import Foundation
@testable import FilmHubb

//Movie

let mockMovie1 = Movie(id: 123,
                       mediaType: "movie",
                       genres: [Genre(id: 1, name: "Action"), Genre(id: 2, name: "Adventure")],
                       runtime: 120,
                       originalName: nil,
                       title: "Mock Movie 1",
                       originalTitle: "Original Mock Movie 1",
                       posterPath: "/mock_poster_1.jpg",
                       backdropPath: "/mock_backdrop_1.jpg",
                       overview: "This is a mock movie for unit testing purposes.",
                       releaseDate: "2023-11-01",
                       voteAverage: 7.8)

let mockMovie2 = Movie(id: 456,
                       mediaType: "movie",
                       genres: [Genre(id: 3, name: "Comedy"), Genre(id: 4, name: "Drama")],
                       runtime: 105,
                       originalName: nil,
                       title: "Mock Movie 2",
                       originalTitle: "Original Mock Movie 2",
                       posterPath: "/mock_poster_2.jpg",
                       backdropPath: "/mock_backdrop_2.jpg",
                       overview: "Another mock movie for testing purposes.",
                       releaseDate: "2023-11-15",
                       voteAverage: 6.5)

//Movie Credit

let mockMovieCredits = MovieCredits(
    id: 123,
    cast: [
        Cast(
            adult: false,
            gender: 1,
            id: 456,
            name: "John Doe",
            originalName: "Original John Doe",
            popularity: 7.8,
            profilePath: "/path/to/actor.jpg",
            castId: 789,
            character: "Character Name",
            creditId: "credit123",
            order: 1,
            department: .acting,
            job: "Actor"
        )
    ],
    crew: [
        Cast(
            adult: false,
            gender: 2,
            id: 789,
            name: "Jane Smith",
            originalName: "Original Jane Smith",
            popularity: 6.5,
            profilePath: "/path/to/crew.jpg",
            castId: 101,
            character: nil,
            creditId: "credit456",
            order: 2,
            department: .production,
            job: "Producer"
        )
    ]
)

//Movie Videos

let mockMovieVideos = MovieVideos(
    id: 123,
    results: [
        Videos(
            name: "Trailer 1",
            key: "video_key_1",
            site: .youTube,
            size: 720,
            type: .trailer,
            official: true,
            publishedAt: "2023-10-27T12:00:00.000Z",
            id: "video_id_1"
        ),
        Videos(
            name: "Teaser 1",
            key: "video_key_2",
            site: .youTube,
            size: 1080,
            type: .teaser,
            official: false,
            publishedAt: "2023-10-28T14:00:00.000Z",
            id: "video_id_2"
        )
    ]
)
