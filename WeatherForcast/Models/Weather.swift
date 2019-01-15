//
//  Weather.swift
//  WeatherForcast
//
//  Created by Armando D Gonzalez on 9/24/18.
//  Copyright © 2018 Armando D Gonzalez. All rights reserved.
//

import Foundation

struct Weather: Codable {
    let weatherStateName: String
    let weatherStateAbbr: String
    let windDirectionCompass: String
    let created: String
    let applicableDate: String
    let minTemp: Float
    let maxTemp: Float
    let theTemp: Float
    let windSpeed: Float
    let windDirection: Float
    let airPressure: Float
    let humidity: Int
    let visibility: Float
    let predictability: Int
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.weatherStateName = try container.decodeIfPresent(String.self, forKey: .weatherStateName) ?? "Not available"
        self.weatherStateAbbr = try container.decodeIfPresent(String.self, forKey: .weatherStateAbbr) ?? "Not available"
        self.windDirectionCompass = try container.decodeIfPresent(String.self, forKey: .windDirectionCompass) ?? "Not available"
        self.created = try container.decodeIfPresent(String.self, forKey: .created) ?? "Not available"
        self.applicableDate = try container.decodeIfPresent(String.self, forKey: .applicableDate) ?? "Not available"
        self.minTemp = try container.decodeIfPresent(Float.self, forKey: .minTemp) ?? 0.0
        self.maxTemp = try container.decodeIfPresent(Float.self, forKey: .maxTemp) ?? 0.0
        self.theTemp = try container.decodeIfPresent(Float.self, forKey: .theTemp) ?? 0.0
        self.windSpeed = try container.decodeIfPresent(Float.self, forKey: .windSpeed) ?? 0.0
        self.windDirection = try container.decodeIfPresent(Float.self, forKey: .windDirection) ?? 0.0
        self.airPressure = try container.decodeIfPresent(Float.self, forKey: .airPressure) ?? 0.0
        self.humidity = try container.decodeIfPresent(Int.self, forKey: .humidity) ?? 0
        self.visibility = try container.decodeIfPresent(Float.self, forKey: .visibility) ?? 0.0
        self.predictability = try container.decodeIfPresent(Int.self, forKey: .predictability) ?? 0
    }
    
    private enum CodingKeys: String, CodingKey {
        case weatherStateName = "weather_state_name"
        case weatherStateAbbr = "weather_state_abbr"
        case windDirectionCompass = "wind_direction_compass"
        case created
        case applicableDate = "applicable_date"
        case minTemp = "min_temp"
        case maxTemp = "max_temp"
        case theTemp = "the_temp"
        case windSpeed = "wind_speed"
        case windDirection = "wind_direction"
        case airPressure = "air_pressure"
        case humidity
        case visibility
        case predictability
    }
}
