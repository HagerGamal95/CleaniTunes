//
//  CustomError.swift
//  News
//
//  Created by hager gamal on 1/30/21.
//

import Foundation
import Alamofire

protocol ReasonableError: CustomNSError, LocalizedError {
    var reason: String { get }
}

extension ReasonableError {

    var errorUserInfo: [String: Any] {
        return [NSLocalizedDescriptionKey: localizedDescription]
    }
    var localizedDescription: String {
        return self.reason
    }
}

struct ResponseError: ReasonableError {
    let reason: String
//    init(response: BaseResponseProtocol) {
//        self.reason = response.Message ?? ""
//    }
}

struct ServiceError: ReasonableError {
    public let category: Category
    private let internalError: Error

    public init(error: Error) {
        self.internalError = error
        self.category = Category(error: error)
    }

    public var reason: String {
        return internalError.localizedDescription
    }
}

extension ServiceError {
    public enum Category: Equatable {
        case network
        case server
        case mapping
        case cancelled
        case response

        public init(error: Error) {
            if error is DecodingError {
                self = .mapping
            } else if error is AFError {
                self = .server
            } else if let networkError = error as? URLError {
                switch networkError.code {
                case .timedOut, .networkConnectionLost, .notConnectedToInternet:
                    self = .network
                case .cancelled:
                    self = .cancelled
                default:
                    self = .server
                }
            } else if error is ResponseError {
                self = .response
            } else {
                self = .server
            }
        }

        public var localizedDescription: String? {
            switch self {
            case .network:
                return "Network Error"
            case .server:
                return "Server Error"
            case .mapping:
                return "Mapping Error"
            case .response:
                return "Response Error"
            case .cancelled:
                return "Canceled Error"
            }
        }

        public static func == (lhs: Category, rhs: Category) -> Bool {
            switch (lhs, rhs) {
            case (.network, .network),
                 (.server, .server), (.mapping, .mapping),
                 (.response, .response),
                 (.cancelled, .cancelled):
                return true
            default:
                return false
            }
        }
    }
}
