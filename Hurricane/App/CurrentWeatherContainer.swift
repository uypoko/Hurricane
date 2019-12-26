//
//  CurrentWeatherContainer.swift
//  Hurricane
//
//  Created by Ryan on 12/26/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import UIKit

class CurrentWeatherContainer {
    
    func constructViewController() -> CurrentWeatherViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController,
            let viewController = navigationController.topViewController as? CurrentWeatherViewController else {
            fatalError("Failed to instantiate CurrentWeatherViewController")
        }
        
        
        let weatherRepository = WeatherRepositoryImp()
        let viewModel = CurrentWeatherViewModel(weatherRepository: weatherRepository)
        viewController.viewModel = viewModel
        
        return viewController
    }
}
