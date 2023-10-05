//
//  MovieService.swift
//  FilmHubb
//
//  Created by Alphan Ogün on 2.10.2023.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}


class MovieService {
    static let shared = MovieService()
    
    func getMovies(for list: String, completion: @escaping(Result<[Movie], Error>) -> Void) {
        let headers = [
            "accept": "application/json",
            "Authorization": "Bearer \(TOKEN_AUTH)"
        ]
        let urlString = "https://api.themoviedb.org/3/movie/\(list)?language=en-US&page=1"
        guard let nsUrl = NSURL(string: urlString ) else { return }
        let request = NSMutableURLRequest(url: nsUrl as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            guard let data = data, error == nil else {
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let results = try decoder.decode(MoviesResponse.self, from: data)
                completion(.success(results.results))
            } catch {
                completion(.failure(error))
            }
        })
        
        dataTask.resume()
    }
    
    func fetchMovie(forId id: Int, completion: @escaping(Result<Movie, Error>) -> Void) {
        let headers = [
          "accept": "application/json",
          "Authorization": "Bearer \(TOKEN_AUTH)"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.themoviedb.org/3/movie/\(id)?language=en-US")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            guard let data = data, error == nil else {
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(Movie.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        })
        dataTask.resume()
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
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            guard let data = data, error == nil else {
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(MovieCredits.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        })
        dataTask.resume()
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
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            guard let data = data, error == nil else {
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(MovieVideos.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        })
        dataTask.resume()
    }
}
