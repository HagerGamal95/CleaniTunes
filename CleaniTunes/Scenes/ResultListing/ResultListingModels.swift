//
//  ResultListingModels.swift
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

enum ResultListing {
  // MARK: Use cases
  
  enum GetResults {
    struct ViewModel {
        
        struct ResultModel {
            var trackName: String?
            var trackImageURL: URL?
            var artistName: String?
            var wrapperType: WrapperType
            var kind: Kind?
            var previewUrl: URL?
            var longDescription: String?
        }
        var results: [[ResultModel]]
    }
  }
}
