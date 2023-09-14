//  CityView.swift
//  AdelSky
//
//  Created by Adel The Adroit on 14/09/2023.
//

import SwiftUI

// Define a struct to represent the city view
struct CityView: View {
    // Define a state property to store the city name
    @State private var cityName = ""
    // Define a state property to store the city weather data
    @State private var cityWeather: WeatherData?
    
    var body: some View {
        VStack {
            // Add a text field to enter the city name
            HStack{
                TextField("Enter a city name", text: $cityName)
            }
            .padding(10)
            
            // Add a button to fetch the weather data for the city name
            Button("Get Weather") {
                fetchWeatherData(for: cityName)
            }
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            
            // Display weather information if available
            if let cityWeather = cityWeather {
                Text("\(Int(cityWeather.temperature))°C")
                    .font(.custom("", size: 70))
                    .padding()
                
                VStack {
                    Text("\(cityWeather.locationName)")
                        .font(.title2).bold()
                    Text("\(cityWeather.condition)")
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
                if(cityName == "")
                    {
                        EmptyView()
                    }
                else
                    {
                        ProgressView()
                    }
            }
        }
    }
    
    // Fetch weather data for the given city name
    private func fetchWeatherData(for cityName: String) {
        let apiKey = "2ae6cc613328d5b5cdf16fc6985f3a73"
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(apiKey)"
        
        print("API Request URL: \(urlString)")
        
        guard let url = URL(string: urlString) else { return }
        
        // Make a network request to fetch weather data
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
                
                DispatchQueue.main.async {
                    // Update the cityWeather state with fetched data
                    cityWeather = WeatherData(locationName: weatherResponse.name, temperature: weatherResponse.main.temp, condition: weatherResponse.weather.first?.description ?? "")
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}

struct CityView_Previews: PreviewProvider {
    static var previews: some View {
        CityView()
    }
}
