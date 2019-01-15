//
//  Location.swift
//  WeatherForcast
//
//  Created by Armando D Gonzalez on 9/18/18.
//  Copyright © 2018 Armando D Gonzalez. All rights reserved.
//

import Foundation

struct Location: Codable {
    let title: String
    let locationType: String
    let latLon: String
    let woeid: Int
    
    private enum CodingKeys: String, CodingKey {
        case title
        case woeid
        case latLon = "latt_long"
        case locationType = "location_type"
    }
}
