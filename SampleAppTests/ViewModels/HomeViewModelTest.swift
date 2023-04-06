//
//  HomeViewModelTest.swift
//  SampleAppTests
//
//  Created by Muhammad Ihsan Maula on 05/04/23.
//

import XCTest
@testable import SampleApp

class HomeViewModelTest: XCTestCase {
    var sut: HomeViewModel!
    var mockApiService: MockApiService!
    
    override func setUp() {
        super.setUp()
        setupData()
    }
    
    override func tearDown() {
        mockApiService = nil
        sut = nil
        
        super.tearDown()
    }
    
    func setupData() {
        mockApiService = MockApiService()
        sut = .init(apiService: mockApiService)
    }
    
    func testFetchGamesListAndLoadMore() {
        // given
        setupData()
        var mockData: GamesListModel = .init()
        var mockgame: GameModel = .init()
        mockgame.name = "crash bandicoot"
        mockData.results.append(mockgame)
        mockApiService.mockGamesList = mockData
        // when
        sut.fetchGamesList()
        // then
        XCTAssertEqual(sut.getGamesList().count, mockData.results.count)
        // given
        var nextMockData: GamesListModel = .init()
        var nextGame: GameModel = .init()
        nextGame.name = "crash 2"
        nextMockData.results.append(nextGame)
        mockApiService.mockGamesList = nextMockData
        // when
        sut.loadMore()
        // then
        XCTAssertEqual(sut.getGamesList().count, mockData.results.count + nextMockData.results.count)
    }
    
    func testFetchGamesListReturnError() {
        // given
        setupData()
        mockApiService.status = .error
        // when
        sut.fetchGamesList()
        //  then
        XCTAssertEqual(sut.requestState.value, .error)
    }
}
