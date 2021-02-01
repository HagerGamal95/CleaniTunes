//
//  CleaniTunesTests.swift
//  CleaniTunesTests
//
//  Created by hager gamal on 1/29/21.
//

import XCTest
@testable import CleaniTunes

var searchCriteriaResultExpectation = XCTestExpectation()
var searchCriteriaErrorExpectation = XCTestExpectation()

class CleaniTunesTests: XCTestCase {
    var resultAPI: MockResultAPI!
    var viewController: SearchCriteriaViewController!
    var presenter: SearchCriteriaPresenter!
    var searchCriteriaWorker: SearchCriteriaWorker!
    var searchCriteriaInteractor: SearchCriteriaInteractor!
    var searchCriteriaRouter: MockSearchCriteriaRouter!
    
    override func setUpWithError() throws {
        resultAPI = MockResultAPI()
        searchCriteriaWorker = SearchCriteriaWorker(resultsStore: resultAPI)
        searchCriteriaRouter = MockSearchCriteriaRouter()
    }
    
    override func tearDownWithError() throws {
        resultAPI = nil
        viewController = nil
        presenter = nil
        searchCriteriaWorker = nil
        searchCriteriaInteractor = nil
        searchCriteriaRouter = nil
    }
    
    func initComponents(viewController: SearchCriteriaViewController) {
        self.viewController = viewController
        presenter = SearchCriteriaPresenter(viewController: viewController)
        searchCriteriaInteractor = SearchCriteriaInteractor(presenter: presenter, worker: searchCriteriaWorker)
        viewController.setup(presenter: presenter, interactor: searchCriteriaInteractor, router: searchCriteriaRouter)
    }
    
    func testSearchCriteriaResult() {
        initComponents(viewController: SearchCriteriaViewController())
        resultAPI.filename = "MockResults.JSON"
        viewController.fetchResult(term: "", entity: [])
        
        wait(for: [searchCriteriaResultExpectation], timeout: 0.25)
        
        if let result = viewController.router?.dataStore?.results{
            XCTAssertEqual(result[0].artistName, "Billy Simpson")
            XCTAssertEqual(result[3].primaryGenreName, "Kids & Family")
        } else {
            XCTFail()
        }
    }
    
    func testSearchCriteriaError() {
        initComponents(viewController: MockSearchCriteriaViewController())
        if let vc = viewController as? MockSearchCriteriaViewController{
            resultAPI.filename = "MockError.JSON"
            viewController.fetchResult(term: "", entity: [])
            wait(for: [searchCriteriaErrorExpectation], timeout: 0.25)
            XCTAssertNotNil(vc.error)
        }else{
            XCTFail()
        }
        
    }
}

