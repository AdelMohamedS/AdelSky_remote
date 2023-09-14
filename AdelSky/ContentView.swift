//
//  ContentView.swift
//  AdelSky
//
//  Created by Adel The Adroit  on 14/09/2023.
//

import SwiftUI
import CoreLocation

// Define the ContentView struct, which represents the main view
struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var weatherData: WeatherData?
    @State private var isRefreshing = false
    
    var body: some View {
        VStack {
            // Display weather information if available
            if let weatherData = weatherData {
                Text("\(Int(weatherData.temperature))°C")
                    .font(.custom("", size: 70))
                    .padding()
                
                VStack {
                    Text("\(weatherData.locationName)")
                        .font(.title2).bold()
                    Text("\(weatherData.condition)")
                        .font(.body).bold()
                        .foregroundColor(.gray)
                }
                Spacer()
                Text("Adel Inc.")
                    .bold()
                    .padding()
                    .foregroundColor(.gray)
            } else {
                // Display a progress view while weather data is being fetched
                ProgressView()
            }
        }
        .frame(width: 300, height: 300)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .onAppear {
            // Request location when the view appears
            locationManager.requestLocation()
        }
        .onReceive(locationManager.$location) { location in
            // Fetch weather data when the location is updated
            guard let location = location else { return }
            fetchWeatherData(for: location)
        }
    }
    
    // Fetch weather data for the given location
    private func fetchWeatherData(for location: CLLocation) {
        let apiKey = "2ae6cc613328d5b5cdf16fc6985f3a73"
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=\(apiKey)"
        
        print("API Request URL: \(urlString)")
        
        guard let url = URL(string: urlString) else { return }
        
        // Make a network request to fetch weather data
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
                
                DispatchQueue.main.async {
                    // Update the weatherData state with fetched data
                    weatherData = WeatherData(locationName: weatherResponse.name, temperature: weatherResponse.main.temp, condition: weatherResponse.weather.first?.description ?? "")
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
