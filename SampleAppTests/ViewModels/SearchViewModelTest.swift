//
//  SearchViewModelTest.swift
//  SampleAppTests
//
//  Created by Muhammad Ihsan Maula on 06/04/23.
//

import XCTest
@testable import SampleApp

class SearchViewModelTest: XCTestCase {
    var sut: SearchViewModel!
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
        sut.search("crash")
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
        sut.search("crash")
        //  then
        XCTAssertEqual(sut.requestState.value, .error)
    }
}
