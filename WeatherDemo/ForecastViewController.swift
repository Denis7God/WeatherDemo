//
//  ForecastViewController.swift
//  WeatherDemo
//
//  Created by Denis Godovaniuk on 06.12.2020.
//

import UIKit
import Alamofire

class ForecastViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // source passed by segue
    var cityName: String?
    var cityCoordinates: (lon: Double, lat: Double)?
    
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeTemperatureLabel: UILabel!
    @IBOutlet weak var currentWeatherIcon: UIImageView!
    @IBOutlet weak var currentWeatherDescriptionLabel: UILabel!
    @IBOutlet weak var currentPressureLabel: UILabel!
    @IBOutlet weak var currentHumidityLabel: UILabel!
    @IBOutlet weak var currentWindSpeedLabel: UILabel!
    
    @IBOutlet weak var dailyForecastCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = cityName
        dailyForecastCollectionView.dataSource = self
        fetchDetailedWeather()
    }
    
    private func fetchDetailedWeather() {
        AF.request("https://api.openweathermap.org/data/2.5/onecall?lat=\(cityCoordinates!.lat)&lon=\(cityCoordinates!.lon)&units=metric&exclude=minutely,hourly,alerts,daily&appid=986900bfbe7c4bd5be6b29dbec16e89f").responseJSON { response in
            if let data = response.data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                    if let current = json["current"] as? [String : Any] {
                        if let secondsFrom1970 = current["dt"] as? Int {
                            let date = Date(timeIntervalSince1970: TimeInterval(secondsFrom1970))
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "EEEE, dd MMMM, HH:mm"
                            self.currentDateLabel.text = dateFormatter.string(from: date)
                        }
                        if let temp = current["temp"] as? Double {
                            self.currentTemperatureLabel.text = "\(temp > 0 ? "+" : "")\(temp.rounded(withPrecision: 1))°C"
                        }
                        if let temp = current["feels_like"] as? Double {
                            self.feelsLikeTemperatureLabel.text = "\(temp > 0 ? "+" : "")\(temp.rounded(withPrecision: 1))°C"
                        }
                        if let pressure = current["pressure"] as? Double {
                            self.currentPressureLabel.text = String(Int((pressure/Double.HPAtoMMHG).rounded(withPrecision: 0)))
                        }
                        if let humidity = current["humidity"] as? Int {
                            self.currentHumidityLabel.text = String(humidity)
                        }
                        if let windSpeed = current["wind_speed"] as? Double {
                            self.currentWindSpeedLabel.text = String(windSpeed)
                        }
                        if let weather = current["weather"] as? [[String : Any]] {
                            if let condition = weather[0]["main"] as? String {
                                self.currentWeatherDescriptionLabel.text = condition
                            }
                            if let icon = weather[0]["icon"] as? String {
                                AF.request("https://openweathermap.org/img/wn/\(icon)@2x.png").responseData { response in
                                    if let data = response.data {
                                        self.currentWeatherIcon.image = UIImage(data: data)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func fetchDailyWeather(for cell: DailyForecastCollectionViewCell, at indexPath: IndexPath) {
        AF.request("https://api.openweathermap.org/data/2.5/onecall?lat=\(cityCoordinates!.lat)&lon=\(cityCoordinates!.lon)&units=metric&exclude=minutely,hourly,alerts,current&appid=986900bfbe7c4bd5be6b29dbec16e89f").responseJSON { response in
            if let data = response.data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                    if let daily = json["daily"] as? [[String : Any]] {
                        if let secondsFrom1970 = daily[indexPath.row]["dt"] as? Int {
                            let date = Date(timeIntervalSince1970: TimeInterval(secondsFrom1970))
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "EE"
                            cell.weekDayLabel.text = dateFormatter.string(from: date)
                        }
                        if let tempInfo = daily[indexPath.row]["temp"] as? [String : Any] {
                            if let temp = tempInfo["day"] as? Double {
                                cell.dailyTemperatureLabel.text = "\(temp > 0 ? "+" : "")\(Int(temp.rounded(withPrecision: 0)))"
                            }
                        }
                        if let weather = daily[indexPath.row]["weather"] as? [[String : Any]] {
                            if let icon = weather[0]["icon"] as? String {
                                AF.request("https://openweathermap.org/img/wn/\(icon)@2x.png").responseData { response in
                                    if let data = response.data {
                                        cell.dailyWeatherIcon.image = UIImage(data: data)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - CollectionView data source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyForecast", for: indexPath) as! DailyForecastCollectionViewCell
        fetchDailyWeather(for: cell, at: indexPath)
        cell.backgroundColor = indexPath.row % 2 != 0 ? UIColor.white : UIColor(white: 0.9, alpha: 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.size.height
        let width = collectionView.frame.size.width
        return CGSize(width: width * 0.6, height: height)
    }
}

extension Double {
    func rounded(withPrecision numbersAfterPoint: Int) -> Double {
        var base: Double = 1
        for _ in 0..<numbersAfterPoint {
            base *= 10
        }
        let temp = self * base
        return temp.rounded() / base
    }
}

extension Double {
    static let HPAtoMMHG = 1.333333
}
