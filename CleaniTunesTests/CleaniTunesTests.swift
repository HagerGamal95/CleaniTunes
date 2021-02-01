//
//  CleaniTunesTests.swift
//  CleaniTunesTests
//
//  Created by hager gamal on 1/29/21.
//

import XCTest
@testable import CleaniTunes

var searchCriteriaExpectation = XCTestExpectation()

class CleaniTunesTests: XCTestCase {
    var resultAPI: MockResultAPI!
    var viewController: MockSearchCriteriaViewController!
    var presenter: SearchCriteriaPresenter!
    var searchCriteriaWorker: SearchCriteriaWorker!
    var searchCriteriaInteractor: SearchCriteriaInteractor!
    
    override func setUpWithError() throws {
        resultAPI = MockResultAPI()
        viewController = MockSearchCriteriaViewController()
         presenter = SearchCriteriaPresenter(viewController: viewController)
         searchCriteriaWorker = SearchCriteriaWorker(resultsStore: resultAPI)
         searchCriteriaInteractor = SearchCriteriaInteractor(presenter: presenter, worker: searchCriteriaWorker)
    }
    override func tearDownWithError() throws {
        resultAPI = nil
        viewController = nil
        presenter = nil
        searchCriteriaWorker = nil
        searchCriteriaInteractor = nil
    }
    
    func testSearchCriteria() {
        searchCriteriaInteractor.fetchResult(request: SearchCriteria.GetResults.Request(term: "", entity: []))
        
        wait(for: [searchCriteriaExpectation], timeout: 0.1)
        
        let results = viewController.viewModel.results
        
        XCTAssertEqual(results[0].artistName, "Billy Simpson")
        XCTAssertEqual(results[3].primaryGenreName, "Kids & Family")
    }
}
