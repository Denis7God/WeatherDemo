//
//  DailyWeather.swift
//  WeatherDemo
//
//  Created by Denis Godovaniuk on 08.12.2020.
//

import Foundation

struct DailyWeather {
    
    let date: Date
    let temperature: Double
    let weathericonData: Data
    
    init?(json: [String : Any], weatherIconData: Data) {
        guard let dateInSecondsSince1970 = json["dt"] as? Int,
              let temp = json["temp"] as? [String : Double],
              let temperature = temp["day"]
              else { return nil }
        self.date = Date(timeIntervalSince1970: TimeInterval(dateInSecondsSince1970))
        self.temperature = temperature
        self.weathericonData = weatherIconData
    }
}
