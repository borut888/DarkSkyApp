//
//  ConditionsCell.swift
//  DarkSkyApp
//
//  Created by Borut on 25/03/2018.
//  Copyright © 2018 Borut. All rights reserved.
//

import UIKit

final class ConditionsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var btnCheckMarkHumidity: UIButton!
    @IBOutlet weak var btnCheckMarkWind: UIButton!
    @IBOutlet weak var btnCheckMarkPressure: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
