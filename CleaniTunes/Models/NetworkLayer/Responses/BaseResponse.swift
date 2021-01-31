//
//  BaseResponse.swift
//  CleaniTunes
//
//  Created by hager gamal on 1/30/21.
//

import Foundation
public protocol BaseResponseProtocol: Codable {
    var resultCount: Int? { get set }
}
class BaseResponse<T: Codable>: BaseResponseProtocol {
    var resultCount: Int?
    var results: [T]?
}
