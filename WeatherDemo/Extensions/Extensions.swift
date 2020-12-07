//
//  Extensions.swift
//  WeatherDemo
//
//  Created by Denis Godovaniuk on 07.12.2020.
//

import UIKit

extension Double {
    
    // Atmosperic pressure: a constant to convert from hectoPascal value to mm mercury: hPa / 1.(3) = mmHg
    static let HPAtoMMHG = 1.333333
    
    func convertedFromKelvinToCelsius() -> Double {
        var celsius = (self - 273.15) * 10
        celsius.round()
        return celsius / 10
    }
    
    func rounded(withPrecision numbersAfterPoint: Int) -> Double {
        var base: Double = 1
        for _ in 0..<numbersAfterPoint {
            base *= 10
        }
        let temp = self * base
        return temp.rounded() / base
    }
}

extension UITableViewCell {
    
    static var identifier: String {
        return "\(self.classForCoder())"
    }
}

extension UICollectionViewCell {
    
    static var identifier: String {
        return "\(self.classForCoder())"
    }
}
