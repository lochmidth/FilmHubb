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
    func getMovies(for list: String) async throws -> Movies
    func getMovie(forId id: Int) async throws -> Movie
    func fetchCredits(forId id: Int) async throws -> MovieCredits
    func getVideos(forId id: Int) async throws -> MovieVideos
    func searchMovie(withName name: String) async throws -> Movies
}

class MovieService: MovieServicing {
    
    var networkManager: NetworkManaging
    
    init(networkManager: NetworkManaging = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getMovies(for list: String) async throws -> Movies {
                
        let headers = [
            "accept": "application/json",
            "Authorization": "Bearer \(TOKEN_AUTH)"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.themoviedb.org/3/movie/\(list)?language=en-US&page=1")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        do {
            return try await networkManager.performRequest(withRequest: request, responseType: Movies.self)
        } catch {
            throw error
        }
    }
    
    func getMovie(forId id: Int) async throws -> Movie {
        let headers = [
            "accept": "application/json",
            "Authorization": "Bearer \(TOKEN_AUTH)"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.themoviedb.org/3/movie/\(id)?language=en-US")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        do {
            return try await networkManager.performRequest(withRequest: request, responseType: Movie.self)
        } catch {
            throw error
        }
    }
    
    func fetchCredits(forId id: Int) async throws -> MovieCredits {
        let headers = [
            "accept": "application/json",
            "Authorization": "Bearer \(TOKEN_AUTH)"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.themoviedb.org/3/movie/\(id)/credits?language=en-US")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        do {
            return try await networkManager.performRequest(withRequest: request, responseType: MovieCredits.self)
        } catch {
            throw error
        }
    }
    
    func getVideos(forId id: Int) async throws -> MovieVideos {
        
        let headers = [
            "accept": "application/json",
            "Authorization": "Bearer \(TOKEN_AUTH)"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.themoviedb.org/3/movie/\(id)/videos?language=en-US")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        do {
            return try await networkManager.performRequest(withRequest: request, responseType: MovieVideos.self)
        } catch {
            throw error
        }
    }
    
    func searchMovie(withName name: String) async throws -> Movies {
        let headers = [
            "accept": "application/json",
            "Authorization": "Bearer \(TOKEN_AUTH)"
        ]
        
        let query = name.replacingOccurrences(of: " ", with: "+")
        
        let urlString = "https://api.themoviedb.org/3/search/movie?query=\(query)&include_adult=false&language=en-US&page=1"
        guard let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return Movies(results: [])}
        
        let request = NSMutableURLRequest(url: NSURL(string: encodedString)!
                                          as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        do {
            return try await networkManager.performRequest(withRequest: request, responseType: Movies.self)
        } catch {
            throw error
        }
    }
}


