//
//  ResultDetailsInteractor.swift
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

protocol ResultDetailsBusinessLogic {
    func getResult()
}
typealias ResultModel = ResultListing.GetResults.ViewModel.ResultModel

protocol ResultDetailsDataStore {
    var result: ResultListing.GetResults.ViewModel.ResultModel! { get set }
}

class ResultDetailsInteractor: ResultDetailsBusinessLogic, ResultDetailsDataStore {
    var presenter: ResultDetailsPresentationLogic?
    var result: ResultModel!
    
    // MARK: get Result
    
    func getResult() {
        presenter?.presentResultDetails(result: result)
    }
}
