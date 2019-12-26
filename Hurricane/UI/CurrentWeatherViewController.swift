//
//  CurrentWeatherViewController.swift
//  Hurricane
//
//  Created by Ryan on 12/4/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import UIKit
import CoreLocation
import RxSwift
import RxCocoa

class CurrentWeatherViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel: CurrentWeatherViewModel?
    
    private let locationManager = CLLocationManager()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.hidesWhenStopped = true

        currentLocationButton.addTarget(self, action: #selector(currentLocationTapped(_:)), for: .touchUpInside)
        locationManager.delegate = self
        bindUI()
    }
    
    private func bindUI() {
        guard let viewModel = viewModel else { return }
        viewModel.tempertureSubject
            .map { "\($0) °C" }
            .asDriver(onErrorJustReturn: "0 °C")
            .drive(tempLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.humiditySubject
            .map { "\($0) %" }
            .asDriver(onErrorJustReturn: "0")
            .drive(humidityLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.citySubject
            .asDriver(onErrorJustReturn: "Unknown")
            .drive(cityLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.loading
            .asDriver(onErrorJustReturn: false)
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    @objc func currentLocationTapped(_ sender: UIButton) {
        retrieveCurrentLocation()
    }
    
    private func retrieveCurrentLocation() {
        let status = CLLocationManager.authorizationStatus()
        
        if status == .denied || status == .restricted || !CLLocationManager.locationServicesEnabled() {
            print("You need to enable location service")
            return
        }
        
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        locationManager.requestLocation()
    }

}

extension CurrentWeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            viewModel?.fetchForCurrentLocation(latitude: latitude, longitude: longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
