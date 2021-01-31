//
//  AlamofireExtensions.swift
//  News
//
//  Created by hager gamal on 1/30/21.
//

import Foundation
import Alamofire

extension SessionManager {

    func request(_ request: BaseRequestProtocol) -> DataRequest {
        return self.request(request.url,
                            method: request.method,
                            parameters: request.parameters,
                            encoding: request.method == .get ? URLEncoding.default : JSONEncoding.prettyPrinted,
                            headers: request.headers)
    }
}

extension DataRequest {

    @discardableResult
    func responseObject<T: BaseResponseProtocol>(_: T.Type,
                                                 queue: DispatchQueue? = nil,
                                                 options: JSONSerialization.ReadingOptions = .allowFragments,
                                                 completionHandler: @escaping (Alamofire.DataResponse<T>) -> Void) -> Self {
        return responseJSON(queue: queue, options: options) { (response) in
            switch response.result {
            case .success:
                do {
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.dateDecodingStrategy = .iso8601
                    
                    if let JSONString = String(data: response.data!, encoding: String.Encoding.utf8) {
                       print(JSONString)
                    }
                    
                    let decodedObject = try jsonDecoder.decode(T.self, from: response.data ?? Data())
                    completionHandler(DataResponse(request: response.request, response: response.response, data: response.data, result: .success(decodedObject), timeline: response.timeline))
                    
                } catch {
                    // Error Decoding the response
                    completionHandler(DataResponse(request: response.request, response: response.response, data: response.data, result: .failure(error), timeline: response.timeline))
                }
            case .failure(let error):
                // Error executing the request
                completionHandler(DataResponse(request: response.request, response: response.response, data: response.data, result: .failure(error), timeline: response.timeline))
            }
        }
    }
}
