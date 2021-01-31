//
//  SearchRequest.swift
//  News
//
//  Created by hager gamal on 1/30/21.
//

import Foundation
import Alamofire

struct  SearchRequest: BaseRequestProtocol {
    let term: String
    let entity: String
    
    var url: String {
        return "https://itunes.apple.com/search"
    }
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: Parameters {
        let parameter = ["term": self.term,
                         "entity": self.entity] as [String: Any]
        
        return parameter
    }
    
    var headers: HTTPHeaders {
        return [KeyParameters.contentTypeKey: KeyParametersValues.contentTypeKey]
    }
}
struct KeyParameters {
    static var contentTypeKey = "Content-Type"
}
struct KeyParametersValues {
    static var contentTypeKey = "application/json"
}
