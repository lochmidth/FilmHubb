//
//  MovieService.swift
//  FilmHubb
//
//  Created by Alphan Ogün on 2.10.2023.
//

import UIKit
import CoreData

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}

protocol MovieServicing {
    func getMovies(for list: String, completion: @escaping(Result<Movies, Error>) -> Void)
    func getMovie(forId id: Int, completion: @escaping(Result<Movie, Error>) -> Void)
    func fetchCredits(forId id: Int, completion: @escaping(Result<MovieCredits, Error>) -> Void)
    func getVideos(forId id: Int, completion: @escaping(Result<MovieVideos, Error>) -> Void)
    func searchMovie(withName name: String, completion: @escaping(Result<Movies, Error>) -> Void)
}

class MovieService: MovieServicing {
    
    var networkManager: NetworkManaging
    
    init(networkManager: NetworkManaging = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getMovies(for list: String, completion: @escaping(Result<Movies, Error>) -> Void) {
                
        let headers = [
            "accept": "application/json",
            "Authorization": "Bearer \(TOKEN_AUTH)"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.themoviedb.org/3/movie/\(list)?language=en-US&page=1")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        networkManager.performRequest(withRequest: request, responseType: Movies.self, completion: completion)
    }
    
    func getMovie(forId id: Int, completion: @escaping(Result<Movie, Error>) -> Void) {
        let headers = [
            "accept": "application/json",
            "Authorization": "Bearer \(TOKEN_AUTH)"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.themoviedb.org/3/movie/\(id)?language=en-US")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        networkManager.performRequest(withRequest: request, responseType: Movie.self, completion: completion)
    }
    
    func fetchCredits(forId id: Int, completion: @escaping(Result<MovieCredits, Error>) -> Void) {
        let headers = [
            "accept": "application/json",
            "Authorization": "Bearer \(TOKEN_AUTH)"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.themoviedb.org/3/movie/\(id)/credits?language=en-US")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        networkManager.performRequest(withRequest: request, responseType: MovieCredits.self, completion: completion)
    }
    
    func getVideos(forId id: Int, completion: @escaping(Result<MovieVideos, Error>) -> Void) {
        
        let headers = [
            "accept": "application/json",
            "Authorization": "Bearer \(TOKEN_AUTH)"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.themoviedb.org/3/movie/\(id)/videos?language=en-US")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        networkManager.performRequest(withRequest: request, responseType: MovieVideos.self, completion: completion)
    }
    
    func searchMovie(withName name: String, completion: @escaping(Result<Movies, Error>) -> Void) {
        let headers = [
            "accept": "application/json",
            "Authorization": "Bearer \(TOKEN_AUTH)"
        ]
        
        let query = name.replacingOccurrences(of: " ", with: "+")
        
        let urlString = "https://api.themoviedb.org/3/search/movie?query=\(query)&include_adult=false&language=en-US&page=1"
        guard let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        let request = NSMutableURLRequest(url: NSURL(string: encodedString)!
                                          as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        networkManager.performRequest(withRequest: request, responseType: Movies.self, completion: completion)
    }
}


