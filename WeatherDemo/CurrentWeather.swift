//
//  CityWeather.swift
//  WeatherDemo
//
//  Created by Denis Godovaniuk on 07.12.2020.
//

import Foundation

struct CurrentWeather {
    
    let coordinates: (lon: Double, lat: Double)
    let name: String
    let temperature: Double
    let weatherIconData: Data
    
    
    
    init?(json: [String : Any], weatherIconData: Data) {
        guard let coordinates = json["coord"] as? [String : Double],
              let longitude = coordinates["lon"],
              let latitude = coordinates["lat"],
              let name = json["name"] as? String,
              let mainJSON = json["main"] as? [String : Double],
              let temperature = mainJSON["temp"]
        else { return nil }
        
        self.coordinates = (longitude, latitude)
        self.name = name
        self.temperature = temperature
        self.weatherIconData = weatherIconData
    }
}
