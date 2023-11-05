//
//  NetworkManager.swift
//  FilmHubb
//
//  Created by Alphan Ogün on 30.10.2023.
//

import Foundation

protocol NetworkManaging {
    func performRequest<T: Codable>(withRequest request: NSMutableURLRequest, responseType: T.Type, completion: @escaping(Result<T, Error>) -> Void)
    func performRequest<T: Codable>(withRequest request: NSMutableURLRequest, responseType: T.Type) async throws -> T
}

class NetworkManager: NetworkManaging {
    func performRequest<T: Codable>(withRequest request: NSMutableURLRequest, responseType: T.Type) async throws -> T {
        let (data, _) = try await session.data(for: request as URLRequest)
        
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try self.decoder.decode(T.self, from: data)
    }
    
    var session: URLSession
    var decoder: JSONDecoder
    
    init(session: URLSession = URLSession.shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    func performRequest<T: Codable>(withRequest request: NSMutableURLRequest, responseType: T.Type, completion: @escaping(Result<T, Error>) -> Void) {
        
        let dataTask = session.dataTask(with: request as URLRequest) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? APIError.invalidData))
                return
            }
            
            do {
                self.decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try self.decoder.decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    
}
