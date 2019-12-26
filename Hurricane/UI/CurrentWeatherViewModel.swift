//
//  CurrentWeatherViewModel.swift
//  Hurricane
//
//  Created by Ryan on 12/26/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import Foundation
import RxSwift

class CurrentWeatherViewModel {
    
    let tempertureSubject = BehaviorSubject<Int>(value: 0)
    let humiditySubject = BehaviorSubject<Int>(value: 0)
    let citySubject = BehaviorSubject<String>(value: "Unknown")
    let loading = BehaviorSubject<Bool>(value: false)
    
    private let disposeBag = DisposeBag()
    
    private let weatherRepository: WeatherRepository
    
    init(weatherRepository: WeatherRepository) {
        self.weatherRepository = weatherRepository
    }
    
    func fetchForCurrentLocation(latitude: Double, longitude: Double) {
        loading.onNext(true)
        
        weatherRepository
            .currentWeather(latitude: latitude, longitude: longitude)
            .subscribe(
                onNext: { [weak self] weather in
                    guard let self = self else { return }
                    
                    let temp = weather.temperature
                    self.tempertureSubject.onNext(temp)
                    let hum = weather.humidity
                    self.humiditySubject.onNext(hum)
                    let city = weather.cityName
                    self.citySubject.onNext(city)
                },
                onError: { error in
                    print(error.localizedDescription)
                },
                onCompleted: { [weak self] in
                    self?.loading.onNext(false)
                }
             )
            .disposed(by: disposeBag)
        
    }
    
}
