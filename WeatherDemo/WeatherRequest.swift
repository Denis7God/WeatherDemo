//
//  CityWeatherRequest.swift
//  WeatherDemo
//
//  Created by Denis Godovaniuk on 07.12.2020.
//

import Foundation
import Alamofire

struct WeatherRequest {
        
    private static let apiKey = "986900bfbe7c4bd5be6b29dbec16e89f"
    private static let domainPath = "https://api.openweathermap.org/data/2.5/"
    private static let queryPartWeather = "weather?q="
    private static let queryPartKey = "&appid="
    
    private static let beginningUrlPathFoImage = "https://openweathermap.org/img/wn/"
    private static let endingUrlPathForImage = "@2x.png"
    
    static func getCurrentWeather (for city: String, completion: @escaping(Result<CurrentWeather, AFError>) -> Void) {
        let currentWeatherResourceURL = URL(string: WeatherRequest.domainPath + WeatherRequest.queryPartWeather + city + WeatherRequest.queryPartKey + WeatherRequest.apiKey)!
        AF.request(currentWeatherResourceURL).responseJSON { response in
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
                                let error = AFError.responseValidationFailed(reason: .dataFileReadFailed(at: currentWeatherResourceURL))
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
        let iconURL = URL(string: WeatherRequest.beginningUrlPathFoImage + iconString + WeatherRequest.endingUrlPathForImage)!
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
    
}
