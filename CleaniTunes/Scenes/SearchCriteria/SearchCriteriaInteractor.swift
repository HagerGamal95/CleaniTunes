//
//  SearchCriteriaInteractor.swift
//  CleaniTunes
//
//  Created by hager gamal on 1/29/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SearchCriteriaBusinessLogic {
    func fetchResult(request: SearchCriteria.GetResults.Request)
}

protocol SearchCriteriaDataStore {
    var results: [Result]? { get set }
}

class SearchCriteriaInteractor: SearchCriteriaBusinessLogic, SearchCriteriaDataStore {
    var presenter: SearchCriteriaPresentationLogic
    var worker: SearchCriteriaWorker
    var results: [Result]?
    
    init(presenter: SearchCriteriaPresentationLogic, worker: SearchCriteriaWorker = SearchCriteriaWorker()) {
        self.presenter = presenter
        self.worker = worker
    }
    
    // MARK: fetch Result
    
    func fetchResult(request: SearchCriteria.GetResults.Request) {
        worker.fetchResults(request: request, completionHandler: { (results, error) in
            if let error = error {
                self.presenter.presentError(error: error.message)
            } else {
                if results.isEmpty {
                    self.presenter.presentNoData()
                } else {
                    self.results = results
                    let response = SearchCriteria.GetResults.Response(results: results)
                    self.presenter.presentResultsList(response: response)
                }
            }
        })
        
    }
}
