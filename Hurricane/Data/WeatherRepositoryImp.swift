//
//  WeatherRepositoryImp.swift
//  Hurricane
//
//  Created by Ryan on 12/3/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

struct WeatherRepositoryImp: WeatherRepository {
    private let baseURL = URL(string: "http://api.openweathermap.org/data/2.5")!
    private let path = "weather"
    private let apiKey = ""
    
    func currentWeather(city: String) -> Observable<Weather> {
        return buildRequest(params: ["city": city])
    }
    
    func currentWeather(latitude: String, longitude: String) -> Observable<Weather> {
        let params = ["lat": latitude, "lon": longitude]
        return buildRequest(params: params)
    }
    
    private func buildRequest(params: [String: String]) -> Observable<Weather> {
        return Observable.create { observer in
            var parameters: [String: String] = [
                "appid": self.apiKey,
                "units": "metric"
            ]
            parameters.merge(params) { current, _ in current }
            
            AF.request(
                self.baseURL.appendingPathComponent(self.path),
                method: .get,
                parameters: parameters,
                encoder: URLEncodedFormParameterEncoder.default)
                .responseDecodable(of: Weather.self) { response in
                    switch response.result {
                    case .success(let weather):
                        observer.onNext(weather)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            
            return Disposables.create()
        }
        
    }
}


