//
//  MockNetworkManager.swift
//  FilmHubbTests
//
//  Created by Alphan Ogün on 30.10.2023.
//

import Foundation
@testable import FilmHubb

class MockNetworkManager: NetworkManaging {
    
    var result: Result<Any, Error>?
    
    var isPerformRequestCalled = false
    
    func performRequest<T>(withRequest request: NSMutableURLRequest, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable, T : Encodable {
        
        isPerformRequestCalled = true
        
        if let result = result {
            switch result {
            case .success(let value as T):
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            default:
                completion(.failure(MockAPIError.someError))
            }
        }
    }
}
