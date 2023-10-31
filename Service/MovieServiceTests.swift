//
//  MovieServiceTests.swift
//  FilmHubbTests
//
//  Created by Alphan Ogün on 30.10.2023.
//

import XCTest
@testable import FilmHubb

final class MovieServiceTests: XCTestCase {

    func test_givenValidList_whenGetMoviesForList_thenSuccess() {
        //WHEN
        let movies = Movies(results: [mockMovie1, mockMovie2])
        
        let mockNetworkManager = MockNetworkManager()
        mockNetworkManager.result = .success(movies)
        
        let sut = MovieService(networkManager: mockNetworkManager)
        
        let expectation = XCTestExpectation(description: "Movies with given list name fetched")
        
        //WHEN
        sut.getMovies(for: "popular") { results in
            switch results {
            case .success(let movies):
                XCTAssertTrue(mockNetworkManager.isPerformRequestCalled)
                XCTAssertTrue(!movies.results.isEmpty)
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_givenInvalidList_whenGetMoviesForList_thenFail() {
        //WHEN
        let mockNetworkManager = MockNetworkManager()
        mockNetworkManager.result = .failure(MockAPIError.invalidList)
        
        let sut = MovieService(networkManager: mockNetworkManager)
        
        let expectation = XCTestExpectation(description: "Movies with given invalid list name fetch failed")
        
        //WHEN
        sut.getMovies(for: "pupolur") { results in
            switch results {
            case .success(let movies):
                XCTAssertTrue(movies.results.isEmpty)
            case .failure(let error):
                XCTAssertTrue(mockNetworkManager.isPerformRequestCalled)
                XCTAssertEqual(error as! MockAPIError, MockAPIError.invalidList)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_givenValidId_whenGetMovieForId_thenSuccess() {
        //WHEN
        let mockNetworkManager = MockNetworkManager()
        mockNetworkManager.result = .success(mockMovie1)
        
        let sut = MovieService(networkManager: mockNetworkManager)
        
        let expectation = XCTestExpectation(description: "Movies with given id name fetch failed")
        
        //WHEN
        sut.getMovie(forId: 123) { results in
            switch results {
            case .success(let movie):
                XCTAssertTrue(mockNetworkManager.isPerformRequestCalled)
                XCTAssertEqual(movie.id, 123)
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_givenInvalidId_whenMovieForId_thenFail() {
        //WHEN
        let mockNetworkManager = MockNetworkManager()
        mockNetworkManager.result = .failure(MockAPIError.invalidId)
        
        let sut = MovieService(networkManager: mockNetworkManager)
        
        let expectation = XCTestExpectation(description: "Movies with given invalid id fetch failed")
        
        //WHEN
        sut.getMovie(forId: 124) { results in
            switch results {
            case .success(let movie):
                XCTAssertNil(movie)
            case .failure(let error):
                XCTAssertTrue(mockNetworkManager.isPerformRequestCalled)
                XCTAssertEqual(error as! MockAPIError, MockAPIError.invalidId)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_givenValidId_whenFetchCreditsForId_thenSuccess() {
        //WHEN
        let mockNetworkManager = MockNetworkManager()
        mockNetworkManager.result = .success(mockMovieCredits)
        
        let sut = MovieService(networkManager: mockNetworkManager)
        
        let expectation = XCTestExpectation(description: "Movie Credit with given id name fetch failed")
        
        //WHEN
        sut.fetchCredits(forId: 123) { results in
            switch results {
            case .success(let movieCredits):
                XCTAssertTrue(mockNetworkManager.isPerformRequestCalled)
                XCTAssertEqual(movieCredits.id, 123)
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_givenInvalidId_whenFetchCreditsForId_thenFail() {
        //WHEN
        let mockNetworkManager = MockNetworkManager()
        mockNetworkManager.result = .failure(MockAPIError.invalidId)
        
        let sut = MovieService(networkManager: mockNetworkManager)
        
        let expectation = XCTestExpectation(description: "movie Credits with given invalid id fetch failed")
        
        //WHEN
        sut.getMovie(forId: 124) { results in
            switch results {
            case .success(let movieCredits):
                XCTAssertNil(movieCredits)
            case .failure(let error):
                XCTAssertTrue(mockNetworkManager.isPerformRequestCalled)
                XCTAssertEqual(error as! MockAPIError, MockAPIError.invalidId)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_givenValidId_whenGetVideosForId_thenSuccess() {
        //WHEN
        let mockNetworkManager = MockNetworkManager()
        mockNetworkManager.result = .success(mockMovieVideos)
        
        let sut = MovieService(networkManager: mockNetworkManager)
        
        let expectation = XCTestExpectation(description: "Movie Videos with given id name fetch failed")
        
        //WHEN
        sut.getVideos(forId: 123) { results in
            switch results {
            case .success(let movieVideos):
                XCTAssertTrue(mockNetworkManager.isPerformRequestCalled)
                XCTAssertEqual(movieVideos.id, 123)
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_givenInvalidId_whenGetVideosForId_thenFail() {
        //WHEN
        let mockNetworkManager = MockNetworkManager()
        mockNetworkManager.result = .failure(MockAPIError.invalidId)
        
        let sut = MovieService(networkManager: mockNetworkManager)
        
        let expectation = XCTestExpectation(description: "Movie Videos with given invalid id fetch failed")
        
        //WHEN
        sut.getVideos(forId: 124) { results in
            switch results {
            case .success(let movieVideos):
                XCTAssertNil(movieVideos)
            case .failure(let error):
                XCTAssertTrue(mockNetworkManager.isPerformRequestCalled)
                XCTAssertEqual(error as! MockAPIError, MockAPIError.invalidId)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_givenValidName_whenSearchMovieWithName_thenSuccess() {
        //GIVEN
        let movies = Movies(results: [mockMovie1, mockMovie2])
        
        let mockNetworkManager = MockNetworkManager()
        mockNetworkManager.result = .success(movies)
        
        let sut = MovieService(networkManager: mockNetworkManager)
        
        let expectation = XCTestExpectation(description: "Movies  search with given name fetched")
        
        //WHEN
        sut.searchMovie(withName: "Mock Movie") { results in
            switch results {
            case .success(let movies):
                XCTAssertTrue(mockNetworkManager.isPerformRequestCalled)
                XCTAssertTrue(!movies.results.isEmpty)
                XCTAssertEqual(movies.results.first?.originalTitle, "Original Mock Movie 1")
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_givenInvalidName_whenSearchMovieWithName_thenFail() {
        //GIVEN
        let mockNetworkManager = MockNetworkManager()
        mockNetworkManager.result = .failure(MockAPIError.invalidName)
        
        let sut = MovieService(networkManager: mockNetworkManager)
        
        let expectation = XCTestExpectation(description: "Movies search with given invalid name fetch failed")
        
        //WHEN
        sut.searchMovie(withName: "Mocccck Muuvie") { results in
            switch results {
            case .success(let movies):
                XCTAssertTrue(movies.results.isEmpty)
            case .failure(let error):
                XCTAssertTrue(mockNetworkManager.isPerformRequestCalled)
                XCTAssertEqual(error as! MockAPIError, MockAPIError.invalidName)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
}
