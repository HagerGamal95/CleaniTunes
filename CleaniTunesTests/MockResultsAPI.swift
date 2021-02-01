//
//  MockResultsAPI.swift
//  CleaniTunesTests
//
//  Created by hager gamal on 1/31/21.
//

import Foundation
@testable import CleaniTunes

class MockResultAPI: ResultsStoreProtocol {
    var filename: String!
    
    func fetchResults(request: SearchCriteria.GetResults.Request, completionHandler: @escaping ([Result]?, ResultsStoreError?) -> Void) {
        let data: Data
        
        guard let file = Bundle(for: type(of: self)).url(forResource: filename, withExtension: nil)
        else {
            completionHandler(nil, ResultsStoreError.cannotFetch)
            return
        }
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            completionHandler(nil, ResultsStoreError.cannotFetch)
            return
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let results = try? decoder.decode(BaseResponse<Result>.self, from: data)
        if let results = results?.results {
            completionHandler(results, nil)
        }else{
            completionHandler(nil, ResultsStoreError.cannotFetch)
        }
    }
}
