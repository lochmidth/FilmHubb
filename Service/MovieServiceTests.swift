//
//  MovieServiceTests.swift
//  FilmHubbTests
//
//  Created by Alphan Ogün on 30.10.2023.
//

import XCTest
@testable import FilmHubb

final class MovieServiceTests: XCTestCase {

    func test_givenValidList_whenGetMoviesForList_thenSuccess() async {
        //GIVEN
        let movies = Movies(results: [mockMovie1, mockMovie2])
        
        let mockNetworkManager = MockNetworkManager()
        mockNetworkManager.result = .success(movies)
        
        let sut = MovieService(networkManager: mockNetworkManager)
        
        //WHEN
        do {
            let fetchedMovies = try await sut.getMovies(for: "popular")
            
            //THEN
            XCTAssertTrue(mockNetworkManager.isPerformRequestCalled)
            XCTAssertEqual(fetchedMovies.results.first?.id, movies.results.first?.id)
        } catch {
            XCTAssertNil(error)
        }
    }
    
    func test_givenInvalidList_whenGetMoviesForList_thenFail() async {
        //GIVEN
        let mockNetworkManager = MockNetworkManager()
        mockNetworkManager.result = .failure(MockAPIError.invalidList)
        
        let sut = MovieService(networkManager: mockNetworkManager)
        
        //WHEN
        do {
            let fetchedMovies = try await sut.getMovies(for: "pipiler")
            
            //THEN
            XCTAssertTrue(mockNetworkManager.isPerformRequestCalled)
            XCTAssertTrue(fetchedMovies.results.isEmpty)
        } catch {
            XCTAssertEqual(error as! MockAPIError, MockAPIError.invalidList)
        }
    }
    
    func test_givenValidId_whenGetMovieForId_thenSuccess() async {
        //GIVEN
        let mockNetworkManager = MockNetworkManager()
        mockNetworkManager.result = .success(mockMovie1)
        
        let sut = MovieService(networkManager: mockNetworkManager)
        
        //WHEN
        do {
            let fetchedMovie = try await sut.getMovie(forId: 123)
            
            //THEN
            XCTAssertTrue(mockNetworkManager.isPerformRequestCalled)
            XCTAssertEqual(fetchedMovie.id, 123)
        } catch {
            XCTAssertNil(error)
        }
    }
    
    func test_givenInvalidId_whenMovieForId_thenFail() async {
        //GIVEN
        let mockNetworkManager = MockNetworkManager()
        mockNetworkManager.result = .failure(MockAPIError.invalidId)
        
        let sut = MovieService(networkManager: mockNetworkManager)
        
        //WHEN
        do {
            let fetchedMovie = try await sut.getMovie(forId: 124)
            
            //THEN
            XCTAssertTrue(mockNetworkManager.isPerformRequestCalled)
            XCTAssertNil(fetchedMovie)
        } catch {
            XCTAssertEqual(error as! MockAPIError, MockAPIError.invalidId)
        }
    }
    
    func test_givenValidId_whenFetchCreditsForId_thenSuccess() async {
        //GIVEN
        let mockNetworkManager = MockNetworkManager()
        mockNetworkManager.result = .success(mockMovieCredits)
        
        let sut = MovieService(networkManager: mockNetworkManager)
    
        //WHEN
        do {
            let fetchedCredits = try await sut.fetchCredits(forId: 123)
            
            //THEN
            XCTAssertTrue(mockNetworkManager.isPerformRequestCalled)
            XCTAssertEqual(fetchedCredits.id, 123)
        } catch {
            XCTAssertNil(error)
        }
    }
    
    func test_givenInvalidId_whenFetchCreditsForId_thenFail() async {
        //GIVEN
        let mockNetworkManager = MockNetworkManager()
        mockNetworkManager.result = .failure(MockAPIError.invalidId)
        
        let sut = MovieService(networkManager: mockNetworkManager)
        
        //WHEN
        do {
            let fetchedCredits = try await sut.fetchCredits(forId: 124)
            
            //THEN
            XCTAssertTrue(mockNetworkManager.isPerformRequestCalled)
            XCTAssertNil(fetchedCredits)
        } catch {
            XCTAssertEqual(error as! MockAPIError, MockAPIError.invalidId)
        }
    }
    
    func test_givenValidId_whenGetVideosForId_thenSuccess() async {
        //WHEN
        let mockNetworkManager = MockNetworkManager()
        mockNetworkManager.result = .success(mockMovieVideos)
        
        let sut = MovieService(networkManager: mockNetworkManager)
        
        //WHEN
        do {
            let fetchedVideos = try await sut.getVideos(forId: 123)
            
            //THEN
            XCTAssertTrue(mockNetworkManager.isPerformRequestCalled)
            XCTAssertEqual(fetchedVideos.id, 123)
        } catch {
            XCTAssertNil(error)
        }
    }
    
    func test_givenInvalidId_whenGetVideosForId_thenFail() async {
        //WHEN
        let mockNetworkManager = MockNetworkManager()
        mockNetworkManager.result = .failure(MockAPIError.invalidId)
        
        let sut = MovieService(networkManager: mockNetworkManager)
        
        //WHEN
        do {
            let fetchedVideos = try await sut.getVideos(forId: 124)
            
            //THEN
            XCTAssertTrue(mockNetworkManager.isPerformRequestCalled)
            XCTAssertNil(fetchedVideos)
        } catch {
            XCTAssertEqual(error as! MockAPIError, MockAPIError.invalidId)
        }
    }
    
    func test_givenValidName_whenSearchMovieWithName_thenSuccess() async {
        //GIVEN
        let movies = Movies(results: [mockMovie1, mockMovie2])
        
        let mockNetworkManager = MockNetworkManager()
        mockNetworkManager.result = .success(movies)
        
        let sut = MovieService(networkManager: mockNetworkManager)
        
        //WHEN
        do {
            let fetchedMovies = try await sut.searchMovie(withName: "Mock Movie")
            
            //THEN
            XCTAssertTrue(mockNetworkManager.isPerformRequestCalled)
            XCTAssertEqual(fetchedMovies.results.first?.originalTitle, "Original Mock Movie 1")
        } catch {
            XCTAssertNil(error)
        }
    }
    
    func test_givenInvalidName_whenSearchMovieWithName_thenFail() async {
        //GIVEN
        let mockNetworkManager = MockNetworkManager()
        mockNetworkManager.result = .failure(MockAPIError.invalidName)
        
        let sut = MovieService(networkManager: mockNetworkManager)
        
        //WHEN
        do {
            let fetchedMovies = try await sut.searchMovie(withName: "Muck Movie")
            
            //THEN
            XCTAssertTrue(mockNetworkManager.isPerformRequestCalled)
            XCTAssertNil(fetchedMovies)
        } catch {
            XCTAssertEqual(error as! MockAPIError, MockAPIError.invalidName)
        }
    }
}
