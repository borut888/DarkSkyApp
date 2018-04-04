//
//  SearchModel.swift
//  DarkSkyApp
//
//  Created by Borut on 23/03/2018.
//  Copyright © 2018 Borut. All rights reserved.
//

import Foundation

struct SearchModel: Codable {
    let geonames: [CityNames]
}

struct CityNames: Codable {
    let name: String
    let lng: String
    let lat: String
}

