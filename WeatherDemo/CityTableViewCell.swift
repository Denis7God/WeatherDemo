//
//  CityTableViewCell.swift
//  WeatherDemo
//
//  Created by Denis Godovaniuk on 06.12.2020.
//

import UIKit

class CityTableViewCell: UITableViewCell {
    
    var currentWeather: CurrentWeather?
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    func configure() {
        cityLabel.text = currentWeather?.name
        if let temp = currentWeather?.temperature.convertedFromKelvinToCelsius().rounded(withPrecision: 0) {
            temperatureLabel.text = (temp > 0 ? "+" : "") + String(Int(temp)) + "°C"
        }
        if let data = currentWeather?.weatherIconData {
            weatherImage.image = UIImage(data: data)
        }
    }
}
