//
//  WeatherRepository.swift
//  Hurricane
//
//  Created by Ryan on 12/4/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import RxSwift

protocol WeatherRepository {
    func currentWeather(city: String) -> Observable<Weather>
    func currentWeather(latitude: String, longitude: String) -> Observable<Weather>
}
