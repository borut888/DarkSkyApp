//
//  WeatherAPI.swift
//  DarkSkyApp
//
//  Created by Borut on 28/03/2018.
//  Copyright © 2018 Borut. All rights reserved.
//

import Foundation
import Moya

enum WeatherApi {
    case cityLatAndLon(lat: Float, long: Float)
    case delegateDataFromSearch(lat: String, long: String)
}

extension WeatherApi: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://api.darksky.net/forecast/758cd0eaed401f2706b91526d132fa36/") else { fatalError("baseURL could not be configured") }
        return url 
    }
    
    var path: String {
        switch self {
        case .cityLatAndLon(let lat, let long):
            return "\(lat),\(long)"
        case .delegateDataFromSearch(let lat, long: let long):
            return "\(lat),\(long)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .cityLatAndLon, .delegateDataFromSearch:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    
}
