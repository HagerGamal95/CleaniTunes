//
//  ResultAPI.swift
//  CleaniTunes
//
//  Created by hager gamal on 1/30/21.
//

import Foundation

class ResultsAPI: ResultsStoreProtocol {
    func fetchResults(request: SearchCriteria.Something.Request, completionHandler: @escaping ([Result], ResultsStoreError?) -> Void) {
        let dispatchGroup = DispatchGroup()
        var result = [Result]()
        var resultError: ResultsStoreError?
        for entity in request.entity {
            let searchRequest = SearchRequest(term: request.term, entity: entity)
            dispatchGroup.enter()
            APIFetcher().fetch(request: searchRequest, mappingInResponse: BaseResponse<Result>.self) { response in
                if let results = response.results {
                    result.append(contentsOf: results)
                }
                dispatchGroup.leave()
            } onFailure: { _ in
                    resultError = ResultsStoreError.cannotFetch
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            if let error = resultError, result.isEmpty {
                completionHandler([], error)
            } else {
                completionHandler(result, nil)
            }
        }
    }
}
