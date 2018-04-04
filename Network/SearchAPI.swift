//
//  SearchAPI.swift
//  DarkSkyApp
//
//  Created by Borut on 29/03/2018.
//  Copyright © 2018 Borut. All rights reserved.
//

import Foundation
import Moya

enum SearchAPI {
    case cities(cityName: String,maxRows: String, apiKey: String)
}

extension SearchAPI: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: "http://api.geonames.org") else { fatalError("baseURL could not be configured") }
        return url
    }
    var path: String {
        switch self {
        case .cities:
            return "/searchJSON"
        }
    }
    var method: Moya.Method {
        switch self {
        case .cities:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .cities( let cityName,let maxRows, let apiKey):
            return .requestParameters(parameters: ["q" : cityName,"maxRows" : maxRows, "username" : apiKey], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}
