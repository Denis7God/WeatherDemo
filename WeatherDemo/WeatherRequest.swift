//
//  CityWeatherRequest.swift
//  WeatherDemo
//
//  Created by Denis Godovaniuk on 07.12.2020.
//

import Foundation
import Alamofire

struct WeatherRequest {
    
    let currentWeatherResourceURL: URL
    private let apiKey = "986900bfbe7c4bd5be6b29dbec16e89f"
    private let domainPath = "https://api.openweathermap.org/data/2.5/"
    private let queryPartWeather = "weather?q="
    private let queryPartKey = "&appid="
    
    private let beginningUrlPathFoImage = "https://openweathermap.org/img/wn/"
    private let endingUrlPathForImage = "@2x.png"
    
    init(city: String) {
        let resourceString = domainPath + queryPartWeather + city + queryPartKey + apiKey
        self.currentWeatherResourceURL = URL(string: resourceString)!
    }
    
    func getCurrentWeather (completion: @escaping(Result<CurrentWeather, AFError>) -> Void) {
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
    
    func getWeatherIconData (iconString: String, completion: @escaping(Result<Data, AFError>) -> Void) {
        let iconURL = URL(string: beginningUrlPathFoImage + iconString + endingUrlPathForImage)!
        AF.request(iconURL).responseData { response in
            switch response.result {
            case .success(let iconData):
                completion(.success(iconData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
