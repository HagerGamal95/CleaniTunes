//
//  MockSearchCriteriaViewController.swift
//  CleaniTunesTests
//
//  Created by hager gamal on 1/31/21.
//

import Foundation
@testable import CleaniTunes

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
