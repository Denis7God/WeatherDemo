//
//  CurrentWeather.swift
//  WeatherDemo
//
//  Created by Denis Godovaniuk on 07.12.2020.
//

import Foundation

struct CurrentWeather {
    
    let date: Date
    let coordinates: (lon: Double, lat: Double)
    let name: String
    let temperature: Double
    let feelsLikeTemperature: Double
    let weatherDescription: String
    let pressure: Double
    let humidity: Double
    let windSpeed: Double
    let weatherIconData: Data
    
    init?(json: [String : Any], weatherIconData: Data) {
        guard let coordinates = json["coord"] as? [String : Double],
              let longitude = coordinates["lon"],
              let latitude = coordinates["lat"],
              let name = json["name"] as? String,
              let mainJSON = json["main"] as? [String : Double],
              let temperature = mainJSON["temp"],
              let feelsLikeTemperature = mainJSON["feels_like"],
              let pressure = mainJSON["pressure"],
              let humidity = mainJSON["humidity"],
              let wind = json["wind"] as? [String : Double],
              let windSpeed = wind["speed"],
              let weather = json["weather"] as? [[String : Any]],
              let weatherDescription = weather[0]["main"] as? String,
              let dateInSecondsSince1970 = json["dt"] as? Int
        else { return nil }
        
        self.date = Date(timeIntervalSince1970: TimeInterval(dateInSecondsSince1970))
        self.coordinates = (longitude, latitude)
        self.name = name
        self.temperature = temperature
        self.feelsLikeTemperature = feelsLikeTemperature
        self.pressure = pressure
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.weatherDescription = weatherDescription
        self.weatherIconData = weatherIconData
    }
}
