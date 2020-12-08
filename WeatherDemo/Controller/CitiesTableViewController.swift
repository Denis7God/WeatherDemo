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
        
    var citiesWeather = [CurrentWeather]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // retriving current weather for all cities and updating tableView in a comletion
        WeatherRequest.getWeatherData(for: citiesList) { result in
            switch result {
            case .success(let weatherData):
                self.citiesWeather = weatherData
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
            
        }
    }

    // MARK: - Table view data source

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
        return self.view.frame.height / CGFloat(Constants.cellsInCitiesTVC)
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
