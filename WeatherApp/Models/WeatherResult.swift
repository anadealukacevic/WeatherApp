//
//  WeatherResult.swift
//  WeatherApp
//
//  Created by Anadea Lukačević on 21/01/2021.
//

import Foundation

struct WeatherResult: Decodable {
    let main: Weather
}

extension WeatherResult {
    static var empty: WeatherResult {
        return WeatherResult(main: Weather(temp: 0.0, humidity: 0.0))
    }
}

struct Weather: Decodable {
    let temp: Double
    let humidity: Double
}
