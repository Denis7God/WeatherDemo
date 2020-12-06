//
//  CitiesTableViewController.swift
//  WeatherDemo
//
//  Created by Denis Godovaniuk on 03.12.2020.
//

import UIKit
import Alamofire

class CitiesTableViewController: UITableViewController {
    
    // source for tableView
    var citiesList = ["Odesa", "Mykolaiv", "Dnipro", "Kharkov","Kiev", "Moscow", "Minsk"]
    
    var citiesCoords = [String : (lon: Double, lat: Double)]()
    
    // get data and set cells properties
    func fetchWeatherData(for city: String, to cell: CityTableViewCell) {
        AF.request("https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=986900bfbe7c4bd5be6b29dbec16e89f").responseJSON { response in
            if let data = response.data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                    if let name = json["name"] as? String {
                        cell.cityLabel.text = name
                    }
                    if let coord = json["coord"] as? [String : Any] {
                        if let lon = coord["lon"] as? Double, let lat = coord["lat"] as? Double {
                            self.citiesCoords[cell.cityLabel.text!] = (lon: lon, lat: lat)
                        }
                    }
                    if let main = json["main"] as? [String : Any] {
                        if let temp = main["temp"] as? Double {
                            let tempInC = temp.convertedFromKelvinToCelsius()
                            cell.temperatureLabel.text = "\(tempInC > 0 ? "+" : "")\(tempInC)°C"
                        }
                    }
                    if let weather = json["weather"] as? [[String : Any]] {
                        if let icon = weather[0]["icon"] as? String {
                            AF.request("https://openweathermap.org/img/wn/\(icon)@2x.png").responseData { response in
                                if let data = response.data {
                                    cell.weatherImage.image = UIImage(data: data)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    

        

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath) as! CityTableViewCell
        fetchWeatherData(for: citiesList[indexPath.row], to: cell)
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
            destinationVC.cityName = chosenCell.cityLabel.text
            destinationVC.cityCoordinates = citiesCoords[destinationVC.cityName!]
        }
    }
}

extension Double {
    func convertedFromKelvinToCelsius() -> Double {
        var celsius = (self - 273.15) * 10
        celsius.round()
        return celsius / 10
    }
}
