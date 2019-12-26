//
//  Weather.swift
//  Hurricane
//
//  Created by Ryan on 12/4/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import Foundation
import CoreLocation

struct Weather: Decodable {
    let cityName: String
    let temperature: Int
    let humidity: Int
    let coordinate: CLLocationCoordinate2D

    static let empty = Weather(
        cityName: "Unknown",
        temperature: -1000,
        humidity: 0,
        coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0)
    )

    static let dummy = Weather(
        cityName: "RxCity",
        temperature: 20,
        humidity: 90,
        coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0)
    )

    init(cityName: String,
       temperature: Int,
       humidity: Int,
       coordinate: CLLocationCoordinate2D) {
        self.cityName = cityName
        self.temperature = temperature
        self.humidity = humidity
        self.coordinate = coordinate
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cityName = try values.decode(String.self, forKey: .cityName)

        let mainInfo = try values.nestedContainer(keyedBy: MainKeys.self, forKey: .main)
        temperature = Int(try mainInfo.decode(Double.self, forKey: .temp))
        humidity = try mainInfo.decode(Int.self, forKey: .humidity)
        
        let coordinate = try values.decode(Coordinate.self, forKey: .coordinate)
        self.coordinate = CLLocationCoordinate2D(latitude: coordinate.lat, longitude: coordinate.lon)
    }

    enum CodingKeys: String, CodingKey {
        case cityName = "name"
        case main
        case weather
        case coordinate = "coord"
    }

    enum MainKeys: String, CodingKey {
        case temp
        case humidity
    }

    private struct Coordinate: Decodable {
        let lat: CLLocationDegrees
        let lon: CLLocationDegrees
    }
}
