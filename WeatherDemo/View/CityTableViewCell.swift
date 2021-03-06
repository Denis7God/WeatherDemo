//
//  CityWeatherTableViewCell.swift
//  WeatherDemo
//
//  Created by Denis Godovaniuk on 03.12.2020.
//

import UIKit

class CityTableViewCell: UITableViewCell {
    
    var coordinates: (lat: Double, lon: Double)?
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    
}
