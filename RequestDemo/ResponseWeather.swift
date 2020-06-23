//
//  ResponseWeather.swift
//  RequestDemo
//
//  Created by Mousa Alwaraki on 26/04/2020.
//  Copyright © 2020 Mousa Alwaraki. All rights reserved.
//

import Foundation

struct ResponseWeather: Codable {
    let main: Main?
    let weather: [WeatherThing?]
}

struct Main: Codable {
    let temp: Double?
    let feels_like: Double?
    let temp_min: Double?
    let temp_max: Double?
    let humidity: Double?
}

struct WeatherThing: Codable {
    let main: String?
    let description: String?
    let icon: String?
}
