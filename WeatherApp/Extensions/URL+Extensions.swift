//
//  URL+Extensions.swift
//  WeatherApp
//
//  Created by Anadea Lukačević on 27/01/2021.
//

import Foundation

extension URL {
    static func urlForWeatherAPI(city: String) -> URL? {
        return URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=a9b3ea6baf5a3e2209ba92dafa2b4252")
    }
}
