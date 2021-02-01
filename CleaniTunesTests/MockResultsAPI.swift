//
//  MockResultsAPI.swift
//  CleaniTunesTests
//
//  Created by hager gamal on 1/31/21.
//

import Foundation
@testable import CleaniTunes

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
