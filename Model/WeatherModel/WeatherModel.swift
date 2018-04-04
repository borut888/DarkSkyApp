//
//  WeatherModel.swift
//  DarkSkyApp
//
//  Created by Borut on 18/03/2018.
//  Copyright © 2018 Borut. All rights reserved.
//

import UIKit

struct WeatherModel: Codable {
    let latitude: Double
    let longitude: Double
    let currently: Currently
    let daily: Daily
}


