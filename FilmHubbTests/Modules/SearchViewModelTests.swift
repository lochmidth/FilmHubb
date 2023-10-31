//
//  SearchViewModelTests.swift
//  FilmHubbTests
//
//  Created by Alphan Ogün on 30.10.2023.
//

import XCTest
@testable import FilmHubb

final class SearchViewModelTests: XCTestCase {
    
    func test_givenValidName_whenSearchMovie_thenSuccess() {
        //GIVEN
        let mockService = MockMovieService()
        let movies = Movies(results: [mockMovie1, mockMovie2])
        mockService.searchMovieResult = .success(movies)
        
        let sut = SearchViewModel(movieService: mockService)
        
        let expectation = XCTestExpectation(description: "Movies with given name fetched")
        
        //WHEN
        sut.searchMovie(withName: "Mock Movie") {
            
            //THEN
            XCTAssertTrue(mockService.isSearchMovieCalled)
            XCTAssertTrue(!sut.movies.isEmpty)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_givenInvalidName_whenSearchMovie_thenSuccess() {
        //GIVEN
        let mockService = MockMovieService()
        let movies = Movies(results: [])
        mockService.searchMovieResult = .failure(MockAPIError.invalidName)
        
        let sut = SearchViewModel(movieService: mockService)
        
        let expectation = XCTestExpectation(description: "Movies with given invalid name fetch failed")
        
        //WHEN
        sut.searchMovie(withName: "No Movie") {
            
            //THEN
            XCTAssertTrue(mockService.isSearchMovieCalled)
            XCTAssertTrue(sut.movies.isEmpty)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_givenValidId_whenGetMovieWithId_thenSuccess() {
        //GIVEN
        let mockService = MockMovieService()
        mockService.getMovieResult = .success(mockMovie1)
        
        let sut = SearchViewModel(movieService: mockService)
        
        let expectation = XCTestExpectation(description: "Movie with given ID fetched")
        
        //WHEN
        sut.getMovie(withId: 123) { results in
            
            switch results {
            case .success(let movie):
                XCTAssertTrue(mockService.isGetMovieWithIdCalled)
                XCTAssertEqual(movie.id, 123)
            case .failure(let error):
                XCTAssertNil(error)
            }
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_givenValidId_shouldFail_whenGetMovieWithId_thenFail() {
        //GIVEN
        let mockService = MockMovieService()
        mockService.getMovieResult = .failure(MockAPIError.someError)
        
        let sut = SearchViewModel(movieService: mockService)
        
        let expectation = XCTestExpectation(description: "Movie with given ID fetch failed")
        
        //WHEN
        sut.getMovie(withId: 123) { results in
            
            //THEN
            switch results {
            case .success(let movie):
                XCTAssertNil(movie)
            case .failure(let error):
                XCTAssertTrue(mockService.isGetMovieWithIdCalled)
                XCTAssertEqual(error as! MockAPIError, MockAPIError.someError)
            }
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_givenInvalidId_whenGetMovieWithId_thenFail() {
        //GIVEN
        let mockService = MockMovieService()
        mockService.getMovieResult = .failure(MockAPIError.invalidId)
        let sut = SearchViewModel(movieService: mockService)
        
        let expectation = XCTestExpectation(description: "Movie with given invalid ID fetch failed")
        
        //WHEN
        sut.getMovie(withId: 3) { results in
            
            //THEN
            switch results {
            case .success(let movie):
                XCTAssertNil(movie)
            case .failure(let error):
                XCTAssertTrue(mockService.isGetMovieWithIdCalled)
                XCTAssertEqual(error as! MockAPIError, MockAPIError.invalidId)
            }
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_givenValidId_whenFetchCredits_thenSuccess() {
        //GIVEN
        let mockService = MockMovieService()
        mockService.fetchCreditsResult = .success(mockMovieCredits)
        let sut = SearchViewModel(movieService: mockService)
        
        let expectation = XCTestExpectation(description: "Movie Credits with given ID fetched")

        //WHEN
        sut.getCredits(forId: 123) { results in
            
            //THEN
            switch results {
            case .success(let movieCredit):
                XCTAssertTrue(mockService.isfetchCreditsCalled)
                XCTAssertEqual(movieCredit.id, 123)
            case .failure(let error):
                XCTAssertNil(error)
            }
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_givenInvalidId_whenFetchCredits_thenFail() {
        let mockService = MockMovieService()
        mockService.fetchCreditsResult = .failure(MockAPIError.invalidId)
        let sut = SearchViewModel(movieService: mockService)
        
        let expectation = XCTestExpectation(description: "Movie Credits with incalid ID fetch failed")
        
        //WHEN
        sut.getCredits(forId: 234) { results in
            switch results {
            case .success(let movieCredit):
                XCTAssertNil(movieCredit)
            case .failure(let error):
                XCTAssertTrue(mockService.isfetchCreditsCalled)
                XCTAssertEqual(error as! MockAPIError, MockAPIError.invalidId)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_givenValidId_whenGetMovieVideos_thenSuccess() {
        let mockService = MockMovieService()
        mockService.getVideosResult = .success(mockMovieVideos)
        let sut = SearchViewModel(movieService: mockService)
        
        let expectation = XCTestExpectation(description: "Movie Videos with given ID fetched")
        
        //WHEN
        sut.getMovieVideos(forId: 123) { results in
            switch results {
            case .success(let movieVideos):
                XCTAssertTrue(mockService.isGetVideosCalled)
                XCTAssertEqual(movieVideos.id, 123)
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_givenInvalidId_whenGetMovieVideos_thenFail() {
        let mockService = MockMovieService()
        mockService.getVideosResult = .failure(MockAPIError.invalidId)
        let sut = SearchViewModel(movieService: mockService)
        
        let expectation = XCTestExpectation(description: "Movie Videos with given ID fetched")
        
        //WHEN
        sut.getMovieVideos(forId: 678) { results in
            switch results {
            case .success(let movieVideos):
                XCTAssertNil(movieVideos)
            case .failure(let error):
                XCTAssertTrue(mockService.isGetVideosCalled)
                XCTAssertEqual(error as! MockAPIError, MockAPIError.invalidId)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
}
