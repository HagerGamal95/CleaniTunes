//
//  MockSearchCriteriaRouter.swift
//  CleaniTunesTests
//
//  Created by hager gamal on 2/2/21.
//

import Foundation
@testable import CleaniTunes

class MockSearchCriteriaRouter: SearchCriteriaRouter {
    override func navigateToResultList(result: [Result]) {
        dataStore?.results = result
        searchCriteriaResultExpectation.fulfill()
    }
}
