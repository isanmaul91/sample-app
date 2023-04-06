//
//  FavoriteViewModelTest.swift
//  SampleAppTests
//
//  Created by Muhammad Ihsan Maula on 06/04/23.
//

import XCTest
@testable import SampleApp

class FavoriteViewModelTest: XCTestCase {
    var sut: FavoriteViewModel!
    var mockGameStorage: MockGameStorage!
    
    override func setUp() {
        super.setUp()
        setupData()
    }
    
    override func tearDown() {
        mockGameStorage = nil
        sut = nil
        
        super.tearDown()
    }
    
    func setupData() {
        mockGameStorage = .init()
        sut = .init(gameStorage: mockGameStorage)
    }
    
    func testFetchFavoriteList() {
        // given
        setupData()
        let mockData: GameEntity = .init()
        let mockGamesList: [GameEntity] = [mockData]
        mockGameStorage.mockGamesList = mockGamesList
        // when
        sut.fetchGamesList()
        // then
        XCTAssertEqual(sut.getGamesList().count, mockGamesList.count)
    }
    
    func testFetchGamesListReturnError() {
        // given
        setupData()
        mockGameStorage.status = .error
        // when
        sut.fetchGamesList()
        //  then
        XCTAssertEqual(sut.requestState.value, .error)
    }
}
