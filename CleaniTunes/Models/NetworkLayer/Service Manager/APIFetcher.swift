//
//  APIFetcher.swift
//  News
//
//  Created by hager gamal on 1/30/21.
//

import Foundation
import Alamofire
struct APIFetcher: Fetcher {
    @discardableResult
    func fetch<ResponseType>(request: BaseRequestProtocol, mappingInResponse response: ResponseType.Type, onSuccess: @escaping (ResponseType) -> Void, onFailure: @escaping (ServiceError) -> Void) -> DataRequest? where ResponseType: BaseResponseProtocol {
        let dataRequest = SessionManager.default.request(request).validate().responseObject(response) { response in
            switch response.result {
            case .success(let result):
                onSuccess(result)
            case .failure(let error):
                onFailure(ServiceError(error: error))
            }
        }
        return dataRequest
    }
}
