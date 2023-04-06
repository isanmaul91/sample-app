//
//  DetailViewModelTest.swift
//  SampleAppTests
//
//  Created by Muhammad Ihsan Maula on 06/04/23.
//

import XCTest
@testable import SampleApp

class DetailViewModelTest: XCTestCase {
    var sut: DetailViewModel!
    var mockGameStorage: MockGameStorage!
    var mockApiService: MockApiService!
    
    override func setUp() {
        super.setUp()
        setupData()
    }
    
    override func tearDown() {
        mockGameStorage = nil
        mockApiService = nil
        sut = nil
        
        super.tearDown()
    }
    
    func setupData() {
        mockApiService = .init()
        mockGameStorage = .init()
        sut = .init(apiService: mockApiService,
                    gameStorage: mockGameStorage)
    }
    
    func testGetGameDetail() {
        // given
        setupData()
        var mockgame: GameModel = .init()
        mockgame.name = "crash bandicoot"
        var mockPublisher: PublisherModel = .init()
        mockPublisher.name = "T&T Ent"
        mockgame.publishers = [mockPublisher]
        mockApiService.mockGame = mockgame
        // when
        sut.getGameDetail()
        // then
        XCTAssertEqual(sut.name, mockgame.name)
        XCTAssertEqual(sut.publisherName, mockPublisher.name)
        XCTAssertEqual(sut.requestState.value, .success)
    }
    
    func testFetchGamesListReturnError() {
        // given
        setupData()
        mockApiService.status = .error
        // when
        sut.getGameDetail()
        //  then
        XCTAssertEqual(sut.requestState.value, .error)
    }
    
    func testAddFavoriteReturnSuccess() {
        // given
        setupData()
        var mockgame: GameModel = .init()
        mockgame.name = "crash bandicoot"
        sut.set(mockgame)
        sut.isFavorite = false
        mockGameStorage.status = .success
        // when
        sut.onTapLove()
        // then
        XCTAssertEqual(sut.isFavorite, true)
        XCTAssertEqual(sut.favoriteState.value, .success)
    }
    
    func testAddFavoriteReturnError() {
        // given
        setupData()
        var mockgame: GameModel = .init()
        mockgame.name = "crash bandicoot"
        sut.set(mockgame)
        sut.isFavorite = false
        mockGameStorage.status = .error
        // when
        sut.onTapLove()
        // then
        XCTAssertEqual(sut.isFavorite, false)
    }
    
    func testDeleteFavoriteReturnSuccess() {
        // given
        setupData()
        sut.set(123)
        sut.isFavorite = true
        // when
        sut.onTapLove()
        // then
        XCTAssertEqual(sut.isFavorite, false)
        XCTAssertEqual(sut.favoriteState.value, .success)
    }
    
    func testDeleteFavoriteReturnError() {
        // given
        setupData()
        sut.set(123)
        sut.isFavorite = true
        mockGameStorage.status = .error
        // when
        sut.onTapLove()
        // then
        XCTAssertEqual(sut.isFavorite, true)
    }
    
    func testSetFavoriteGames() {
        setupData()
        var mockgame: GameModel = .init()
        mockgame.name = "crash bandicoot"
        var mockPublisher: PublisherModel = .init()
        mockPublisher.name = "T&T Ent"
        mockgame.publishers = [mockPublisher]
        mockApiService.mockGame = mockgame
        mockGameStorage.status = .error
        mockGameStorage.mockErrorResponse = GameStorageError.cannotFind
        // when
        sut.getGameDetail()
        // then
        XCTAssertEqual(sut.name, mockgame.name)
        XCTAssertEqual(sut.publisherName, mockPublisher.name)
        XCTAssertEqual(sut.requestState.value, .success)
        XCTAssertEqual(sut.isFavorite, false)
    }
}
