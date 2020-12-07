//
//  CitiesTableViewController.swift
//  WeatherDemo
//
//  Created by Denis Godovaniuk on 03.12.2020.
//

import UIKit
import Alamofire

class CitiesTableViewController: UITableViewController {
    
    var citiesList = ["Odessa", "Mykolaiv", "Dnipro", "Kharkov", "Kiev", "Moscow", "Minsk"]
    
    func getWeatherData(completion: @escaping( ([CurrentWeather]) -> Void )) {
        var weatherData = [CurrentWeather]()
        for city in citiesList {
            let request = WeatherRequest(city: city)
            request.getCurrentWeather { result in
                switch result {
                case.success(let cityWeather):
                    weatherData.append(cityWeather)
                    if weatherData.count == self.citiesList.count {
                        completion(weatherData)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
        
    var citiesWeather = [CurrentWeather]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getWeatherData { weatherData in
            self.citiesWeather = weatherData
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesWeather.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.identifier, for: indexPath) as! CityTableViewCell
        cell.currentWeather = citiesWeather[indexPath.row]
        cell.configure()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height / 12
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Show Forecast", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Forecast" {
            let destinationVC = segue.destination as! ForecastViewController
            let chosenCell = tableView.cellForRow(at: tableView.indexPathForSelectedRow!)! as! CityTableViewCell
            destinationVC.cityName = chosenCell.currentWeather?.name
            destinationVC.cityCoordinates = chosenCell.currentWeather?.coordinates
        }
    }
}
