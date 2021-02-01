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
    func testSearchCriteria() {
        let resultAPI = MockResultAPI()
        let viewController = MockSearchCriteriaViewController()
        let presenter = SearchCriteriaPresenter(viewController: viewController)
        let searchCriteriaWorker = SearchCriteriaWorker(resultsStore: resultAPI)
        let searchCriteriaInteractor = SearchCriteriaInteractor(presenter: presenter, worker: searchCriteriaWorker)
        searchCriteriaInteractor.fetchResult(request: SearchCriteria.GetResults.Request(term: "", entity: []))
        
        wait(for: [searchCriteriaExpectation], timeout: 0.1)
        
        let results = viewController.viewModel.results
        
        XCTAssertEqual(results[0].artistName, "Billy Simpson")
    }
}

class MockResultAPI: ResultsStoreProtocol {
    func fetchResults(request: SearchCriteria.GetResults.Request, completionHandler: @escaping ([Result], ResultsStoreError?) -> Void) {
        let filename = "MockResults.JSON"
        let data: Data
        
        guard let file = Bundle(for: type(of: self)).url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let results = try! decoder.decode(BaseResponse<Result>.self, from: data)
        completionHandler(results.results!, nil)
    }
}

class MockSearchCriteriaViewController: SearchCriteriaDisplayLogic {
    var viewModel: SearchCriteria.GetResults.ViewModel!
    
    func navigateToListing(viewModel: SearchCriteria.GetResults.ViewModel) {
        self.viewModel = viewModel
        searchCriteriaExpectation.fulfill()
    }
    
    func showNoDataError() {
    }
    
    func presentError(error: String) {
    }
}
