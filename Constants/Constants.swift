//
//  Constants.swift
//  DarkSkyApp
//
//  Created by Borut on 18/03/2018.
//  Copyright © 2018 Borut. All rights reserved.
//

import Foundation
import UIKit
import Hue

struct Colors {
   static let dayUpColor = UIColor(hex: "59B7E0")
   static let dayDownColor = UIColor(hex: "D8D8D8")
   static let rainLeft = UIColor(hex:"4A75A2")
   static let rainRight = UIColor(hex:"15587B")
   static let snowUp = UIColor(hex: "0B3A4E" )
   static let snowDown = UIColor(hex: "80D5F3")
   static let nightUp = UIColor(hex:"044663")
   static let nightDown = UIColor(hex:"234880")
   static let fogUp = UIColor(hex:"ABD6E9")
   static let fogDown = UIColor(hex:"D8D8D8")
}
struct SegueNames {
    static let segueSearch = "segueSearch"
    static let segueSettings = "segueSettings"
}
struct conditionsData {
    static let showHumidity = "showHumidityData"
    static let hideHumidity = "removeHumidityData"
    static let showWind = "showWindData"
    static let hideWind = "removeWindData"
    static let showPressure = "showPressureData"
    static let hidePressure = "removePressureData"
}
struct cityDataAPI {
    static let numberOfRows = "10"
    static let apyKey = "rukometas8"
}
