//
//  NetworkManager.swift
//  WeatherForcast
//
//  Created by Armando D Gonzalez on 9/18/18.
//  Copyright © 2018 Armando D Gonzalez. All rights reserved.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    private let baseURL = "https://www.metaweather.com/api/location"
    private let baseImageURL = "https://www.metaweather.com/static/img/weather/png/64/"
    private let session = URLSession.shared
    
    private init() {}
    
    func getLocationInfoFor(index: Int = 0, locations: [String], locationInfo: [Location], completion: @escaping ([Location])->()) {
        if index >= locations.count {
            completion(locationInfo)
        } else {
            var locationInfoTemp = locationInfo
            let baseURLTemp = "\(self.baseURL)/search/"
            if var components = URLComponents(string: baseURLTemp) {
                components.queryItems = [
                    URLQueryItem(name: "query", value: locations[index])
                ]
                if let url = components.url {
                    let request = URLRequest(url: url)
                    session.dataTask(with: request) { [unowned self]
                        (data,response,error) in
                        if let error = error {
                            logError("Error creating dataTask - \(error.localizedDescription)")
                        }
                        if let response = response as? HTTPURLResponse, 200 <= response.statusCode, response.statusCode <= 300 {
                            if let data = data {
                                do {
                                    let decoder = JSONDecoder()
                                    let location = try decoder.decode([Location].self,from: data)
                                    locationInfoTemp.append(location[0])
                                    let nextIndex = index + 1
                                    self.getLocationInfoFor(index: nextIndex, locations: locations, locationInfo: locationInfoTemp, completion: completion)
                                } catch let error {
                                    logError("Error parsing Location JSON - \(error.localizedDescription)")
                                }
                            }
                        } else {
                            logError("There was an error with the HTTP Response")
                        }
                    }.resume()
                }
            }
        }
    }
    
    func getWeatherFor(index: Int = 0, locations: [Location], weatherInfo: [String:Weather], completion: @escaping ([String:Weather])->()) {
        if index >= locations.count {
            completion(weatherInfo)
        } else {
            var weatherInfoTemp = weatherInfo
            let tomorrowsDate = Date.tomorrowDateString()
            let location = locations[index]
            let baseURLTemp = "\(self.baseURL)/\(location.woeid)/\(tomorrowsDate)"
            if let url = URL(string: baseURLTemp) {
                let request = URLRequest(url: url)
                session.dataTask(with: request) { [unowned self] 
                    (data,response,error) in
                    if let error = error {
                        logError("Error creating dataTask - \(error.localizedDescription)")
                    }
                    // Begin parsing API response
                    if let response = response as? HTTPURLResponse, 200 <= response.statusCode, response.statusCode <= 300 {
                        if let data = data {
                            do {
                                let decoder = JSONDecoder()
                                let weather = try decoder.decode([Weather].self,from: data)
                                weatherInfoTemp[location.title] = weather[0]
                                let nextIndex = index + 1
                                self.getWeatherFor(index: nextIndex, locations: locations, weatherInfo: weatherInfoTemp, completion: completion)
                            } catch let error {
                                logError("Error parsing Weather json - \(error.localizedDescription)")
                            }
                        }
                    } else {
                        logError("There was an error with the HTTP Response")
                    }
                }.resume()
            }
        }
    }
    
    func getImage(weatherStateAbbreviatin: String, completion: @escaping (Data?) -> Void) {
        let imageURLTemp = baseImageURL + weatherStateAbbreviatin + ".png"
        if let imageURL = URL(string: imageURLTemp) {
            let request = URLRequest(url: imageURL)
            session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    logError("Error getting image: \(error.localizedDescription)")
                }
                if let response = response as? HTTPURLResponse, 200 <= response.statusCode, response.statusCode <= 300 {
                    if let imageData = data {
                        completion(imageData)
                        return
                    }
                } else {
                    logError("Error getting image.")
                    completion(nil)
                }
            }.resume()
        }
    }
}
