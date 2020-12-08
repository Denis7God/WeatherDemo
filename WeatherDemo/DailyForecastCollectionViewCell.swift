//
//  DayForecastCollectionViewCell.swift
//  WeatherDemo
//
//  Created by Denis Godovaniuk on 06.12.2020.
//

import UIKit

class DailyForecastCollectionViewCell: UICollectionViewCell {
    
    var dailyWeather: DailyWeather? {
        didSet {
            self.configure()
        }
    }
    
    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var dailyWeatherIcon: UIImageView!
    @IBOutlet weak var dailyTemperatureLabel: UILabel!
    
    private func configure() {
        if let date = dailyWeather?.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EE"
            weekDayLabel.text = dateFormatter.string(from: date)
        }
        if let data = dailyWeather?.weathericonData {
            dailyWeatherIcon.image = UIImage(data: data)
        }
        if let temp = dailyWeather?.temperature.rounded(withPrecision: 0) {
            dailyTemperatureLabel.text = (temp > 0 ? "+" : "") + String(Int(temp)) + "°C"
        }
    }
}
