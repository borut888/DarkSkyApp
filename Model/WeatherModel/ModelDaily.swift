//
//  ModelDaily.swift
//  DarkSkyApp
//
//  Created by Borut on 27/03/2018.
//  Copyright © 2018 Borut. All rights reserved.
//

import UIKit

struct Daily: Codable {
    let data: [DataWeather]
}

struct DataWeather: Codable {
    let time: Int
    let temperatureMin: Float
    let temperatureMax: Float
}
