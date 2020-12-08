//
//  WeatherRequest.swift
//  WeatherDemo
//
//  Created by Denis Godovaniuk on 07.12.2020.
//

import Foundation
import Alamofire

struct WeatherRequest {
        
    private static let weatherDomainPath = "https://api.openweathermap.org/data/2.5/"
    private static let apiIdentifierForCurrentWeather = "weather?"
    private static let apiIdentifierForWeatherForecast = "onecall?"
    private static let currentWeatherCityArgPath = "q="
    private static let weatherForecastLatArgPath = "lat="
    private static let weatherForecastLonArgPath = "&lon="
    private static let weatherForecastPreferencesPath = "&units=metric&exclude=current,minutely,hourly,alerts"
    private static let apiKey = "&appid=986900bfbe7c4bd5be6b29dbec16e89f"
    
    private static let weatherIconDomainPath = "https://openweathermap.org/img/wn/"
    private static let weatherIconURLFileFormat = "@2x.png"
    
    static func getCurrentWeather (for city: String, completion: @escaping(Result<CurrentWeather, AFError>) -> Void) {
        let currentWeatherURL = URL(string: WeatherRequest.weatherDomainPath + WeatherRequest.apiIdentifierForCurrentWeather + WeatherRequest.currentWeatherCityArgPath + city + WeatherRequest.apiKey)!
        AF.request(currentWeatherURL).responseJSON { response in
            switch response.result {
            case .success(let json as [String : Any]):
                // retriving icon from json to form URL for weather image
                if let weather = json["weather"] as? [[String : Any]], let iconString = weather[0]["icon"] as? String {
                    getWeatherIconData(iconString: iconString) { result in
                        switch result {
                        case .success(let iconData):
                            if let cityWeather = CurrentWeather(json: json, weatherIconData: iconData) {
                                completion(.success(cityWeather))
                            } else {
                                let error = AFError.responseValidationFailed(reason: .dataFileReadFailed(at: currentWeatherURL))
                                completion(.failure(error))
                            }
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            default:
                fatalError("error: bad JSON response")
            }
        }
    }
    
    static func getWeatherIconData (iconString: String, completion: @escaping(Result<Data, AFError>) -> Void) {
        let iconURL = URL(string: WeatherRequest.weatherIconDomainPath + iconString + WeatherRequest.weatherIconURLFileFormat)!
        AF.request(iconURL).responseData { response in
            switch response.result {
            case .success(let iconData):
                completion(.success(iconData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func getWeatherData (for cities: [String], completion: @escaping( (Result<[CurrentWeather], AFError>) -> Void )) {
        var weatherData = [CurrentWeather]()
        for city in cities {
            getCurrentWeather(for: city) { result in
                switch result {
                case.success(let cityWeather):
                    weatherData.append(cityWeather)
                    if weatherData.count == cities.count {
                        completion(.success(weatherData))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    static func getWeatherForecast (forCityAt coordinates: (lon: Double, lat: Double), completion: @escaping(Result<[DailyWeather], AFError>) -> Void) {
        var dailyWeatherForecast = [DailyWeather]()
        let weatherForecastURL = URL(string: weatherDomainPath + apiIdentifierForWeatherForecast + weatherForecastLatArgPath + String(coordinates.lat) + weatherForecastLonArgPath + String(coordinates.lon) + weatherForecastPreferencesPath + apiKey)!
        AF.request(weatherForecastURL).responseJSON { response in
            switch response.result {
            case .success(let json as [String : Any]):
                if let dailyJSON = json["daily"] as? [[String : Any]] {
                    for day in 0..<dailyJSON.count {
                        let jsonForADay = dailyJSON[day]
                        if let weather = jsonForADay["weather"] as? [[String : Any]], let iconString = weather[0]["icon"] as? String {
                            getWeatherIconData(iconString: iconString) { result in
                                switch result {
                                case .success(let iconData):
                                    if let dailyWeather = DailyWeather(json: jsonForADay, weatherIconData: iconData){
                                        dailyWeatherForecast.append(dailyWeather)
                                        if dailyWeatherForecast.count == dailyJSON.count {
                                            completion(.success(dailyWeatherForecast))
                                        }
                                    } else {
                                        let error = AFError.responseValidationFailed(reason: .dataFileReadFailed(at: weatherForecastURL))
                                        completion(.failure(error))
                                    }
                                case .failure(let error):
                                    completion(.failure(error))
                                }
                            }
                        }
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            default:
                fatalError("error: bad JSON response")
            }
        }
    }
}
