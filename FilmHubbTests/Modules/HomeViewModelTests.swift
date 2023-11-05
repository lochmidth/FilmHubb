//
//  HomeViewModelTests.swift
//  FilmHubbTests
//
//  Created by Alphan Ogün on 26.10.2023.
//

import XCTest
@testable import FilmHubb

final class HomeViewModelTests: XCTestCase {

    func test_givenNothing_whenGetMovies_thenSuccess() async {
        //GIVEN
        let movies = Movies(results: [mockMovie1, mockMovie2])
        
        let mockService = MockMovieService()
        
        mockService.getMoviesResult = .success(movies)
        let sut = HomeViewModel(movieService: mockService)
        let delegate = MockHomeViewModelDelegate()
        sut.delegate = delegate
        
        //WHEN
        do {
            try await sut.getMovies()
            
            //THEN
            XCTAssertTrue(mockService.isGetMoviesCalled)
            XCTAssertFalse(sut.sections[0].movies.isEmpty)
            XCTAssertFalse(sut.sections[1].movies.isEmpty)
            XCTAssertFalse(sut.sections[2].movies.isEmpty)
            XCTAssertFalse(sut.sections[3].movies.isEmpty)
            XCTAssertTrue(delegate.isDidFetchMoviesCalled)
        } catch {
            XCTAssertNil(error)
        }
    }
    
    func test_givenShouldFail_whenGetMovies_thenFail() async{
        //GIVEN
        let mockService = MockMovieService()
        mockService.getMoviesResult = .failure(MockAPIError.someError)
        
        let sut = HomeViewModel(movieService: mockService)

        //WHEN
        do {
            try await sut.getMovies()
            
            //THEN
            XCTAssertTrue(mockService.isGetMoviesCalled)
            XCTAssertTrue(sut.sections[0].movies.isEmpty)
            XCTAssertTrue(sut.sections[1].movies.isEmpty)
            XCTAssertTrue(sut.sections[2].movies.isEmpty)
            XCTAssertTrue(sut.sections[3].movies.isEmpty)
        } catch {
            XCTAssertEqual(error as! MockAPIError, MockAPIError.someError)
        }
    }
    
    func test_givenValidId_whenGetMovieWithId_thenSuccess() async {
        //GIVEN
        let mockService = MockMovieService()
        mockService.getMovieResult = .success(mockMovie1)
        
        let sut = HomeViewModel(movieService: mockService)
        
        //WHEN
        do {
            let fetchedMovie = try await sut.getMovie(withId: 123)
            
            //THEN
            XCTAssertTrue(mockService.isGetMovieWithIdCalled)
            XCTAssertEqual(fetchedMovie.id, 123)
        } catch {
            XCTAssertNil(error)
        }
    }
    
    func test_givenInvalidId_whenGetMovieWithId_thenFail() async {
        //GIVEN
        let mockService = MockMovieService()
        mockService.getMovieResult = .failure(MockAPIError.invalidId)
        
        let sut = HomeViewModel(movieService: mockService)
        
        //WHEN
        do {
            let fetchedMovie = try await sut.getMovie(withId: 124)
            
            //THEN
            XCTAssertTrue(mockService.isGetMovieWithIdCalled)
            XCTAssertNil(fetchedMovie)
        } catch {
            XCTAssertEqual(error as! MockAPIError, MockAPIError.invalidId)
        }
        
    }

    func test_givenValidId_whenFetchCredits_thenSuccess() async {
        //GIVEN
        let mockService = MockMovieService()
        mockService.fetchCreditsResult = .success(mockMovieCredits)
        let sut = HomeViewModel(movieService: mockService)

        //WHEN
        do {
            let fetchedCredits = try await sut.getCredits(forId: 123)
            
            //THEN
            XCTAssertTrue(mockService.isfetchCreditsCalled)
            XCTAssertEqual(fetchedCredits.id, 123)
        } catch {
            XCTAssertNil(error)
        }
    }
    
    func test_givenInvalidId_whenFetchCredits_thenFail() async {
        let mockService = MockMovieService()
        mockService.fetchCreditsResult = .failure(MockAPIError.invalidId)
        let sut = HomeViewModel(movieService: mockService)
        
        //WHEN
        do {
            let fetchedCredits = try await sut.getCredits(forId: 124)
            
            //THEN
            XCTAssertTrue(mockService.isfetchCreditsCalled)
            XCTAssertNil(fetchedCredits)
        } catch {
            XCTAssertEqual(error as! MockAPIError, MockAPIError.invalidId)
        }
    }
    
    func test_givenValidId_whenGetMovieVideos_thenSuccess() async {
        let mockService = MockMovieService()
        mockService.getVideosResult = .success(mockMovieVideos)
        let sut = HomeViewModel(movieService: mockService)
        
        //WHEN
        do {
            let fetchedVideos = try await sut.getMovieVideos(forId: 123)
            
            //THEN
            XCTAssertTrue(mockService.isGetVideosCalled)
            XCTAssertEqual(fetchedVideos.id, 123)
        } catch {
            XCTAssertNil(error)
        }
    }
    
    func test_givenInvalidId_whenGetMovieVideos_thenFail() async {
        let mockService = MockMovieService()
        mockService.getVideosResult = .failure(MockAPIError.invalidId)
        let sut = HomeViewModel(movieService: mockService)
        
        //WHEN
        do {
            let fetchedVideos = try await sut.getMovieVideos(forId: 124)
            
            //THEN
            XCTAssertTrue(mockService.isGetVideosCalled)
            XCTAssertNil(fetchedVideos)
        } catch {
            XCTAssertEqual(error as! MockAPIError, MockAPIError.invalidId)
        }
    }
    
}
