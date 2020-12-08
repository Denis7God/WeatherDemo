//
//  ForecastViewController.swift
//  WeatherDemo
//
//  Created by Denis Godovaniuk on 06.12.2020.
//

import UIKit
import Alamofire

class ForecastViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var currentWeather: CurrentWeather?
    
    var dailyWeatherForecast = [DailyWeather]()
    
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
        
        dailyForecastCollectionView.dataSource = self
        
        configure()
        WeatherRequest.getWeatherForecast(forCityAt: currentWeather!.coordinates) { result in
            switch result {
            case .success(let dailyWeatherForecast):
                self.dailyWeatherForecast = dailyWeatherForecast
                self.dailyForecastCollectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func configure () {
        navigationItem.title = currentWeather!.name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, dd MMMM, HH:mm"
        currentDateLabel.text = dateFormatter.string(from: currentWeather!.date)
        let temp = currentWeather!.temperature.convertedFromKelvinToCelsius().rounded(withPrecision: 1)
        currentTemperatureLabel.text = (temp > 0 ? "+" : "") + String(temp) + "°C"
        let tempF = currentWeather!.feelsLikeTemperature.convertedFromKelvinToCelsius().rounded(withPrecision: 1)
        feelsLikeTemperatureLabel.text = (tempF > 0 ? "+" : "") + String(tempF) + "°C"
        currentWeatherIcon.image = UIImage(data: currentWeather!.weatherIconData)
        currentWeatherDescriptionLabel.text = currentWeather!.weatherDescription
        currentPressureLabel.text = String(Int((currentWeather!.pressure / Double.HPAtoMMHG).rounded(withPrecision: 0)))
        currentHumidityLabel.text = String(Int(currentWeather!.humidity))
        currentWindSpeedLabel.text = String(currentWeather!.windSpeed)
    }
    
    //MARK: - CollectionView data source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dailyWeatherForecast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DailyForecastCollectionViewCell.identifier, for: indexPath) as! DailyForecastCollectionViewCell
        cell.dailyWeather = dailyWeatherForecast[indexPath.row]
        cell.backgroundColor = indexPath.row % 2 != 0 ? UIColor.white : UIColor(white: 0.9, alpha: 1)
        return cell
    }
}


