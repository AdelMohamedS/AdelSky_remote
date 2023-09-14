//
//  WeatherData.swift
//  AdelSky
//
//  Created by Adel The Adroit  on 14/09/2023.
//


// Import necessary frameworks
import Foundation
import CoreLocation

// Define a struct to hold weather data
struct WeatherData {
    let locationName: String
    let temperature: Double
    let condition: String
}

// Define a struct to represent the weather response
struct WeatherResponse: Codable {
    let name: String
    let main: MainWeather
    let weather: [Weather]
}

// Define a struct to represent the main weather details
struct MainWeather: Codable {
    let temp: Double
}


struct Weather: Codable {
    let description: String
}


class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        locationManager.stopUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

