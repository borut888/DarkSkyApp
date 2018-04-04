//
//  ModelCurrently.swift
//  DarkSkyApp
//
//  Created by Borut on 27/03/2018.
//  Copyright © 2018 Borut. All rights reserved.
//

import UIKit

struct Currently: Codable {
    let humidity: Float
    let icon: String
    let pressure: Float
    let temperature: Float
    let time: Int
    let windSpeed: Float
    let summary: String
}
