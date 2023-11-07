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
    
    func performRequest<T: Codable>(withRequest request: NSMutableURLRequest, responseType: T.Type) async throws -> T {
        isPerformRequestCalled = true
        
        if let result = result {
            switch result {
            case .success(let value as T):
                return value
            case .failure(let error):
                throw error
            default:
                throw MockAPIError.someError
            }
        } else {
            throw MockAPIError.someError
        }
    }

}
