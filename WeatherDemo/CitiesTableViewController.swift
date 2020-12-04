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
    
    // get data and set cells properties
    func fetchWeatherData(for city: String, to cell: CityTableViewCell) {
        AF.request("https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=986900bfbe7c4bd5be6b29dbec16e89f").responseJSON { response in
            if let data = response.data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                    if let name = json["name"] as? String {
                        cell.cityLabel.text = name
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
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension Double {
    func convertedFromKelvinToCelsius() -> Double {
        var celsius = (self - 273.15) * 10
        celsius.round()
        return celsius / 10
    }
}
