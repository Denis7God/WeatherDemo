//
//  UITableViewCell.swift
//  WeatherDemo
//
//  Created by Denis Godovaniuk on 08.12.2020.
//

import UIKit

extension UITableViewCell {
    
    static var identifier: String {
        return "\(self.classForCoder())"
    }
}
