//
//  MockSearchCriteriaViewController.swift
//  CleaniTunesTests
//
//  Created by hager gamal on 1/31/21.
//

import Foundation
@testable import CleaniTunes

class MockSearchCriteriaViewController: SearchCriteriaViewController {
    var error: String!
    
    override func presentError(error: String) {
        self.error = error
        searchCriteriaErrorExpectation.fulfill()
        searchCriteriaValidationExpectation.fulfill()
    }
}
