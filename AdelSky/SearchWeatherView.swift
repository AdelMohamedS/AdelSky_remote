import SwiftUI

struct SearchWeatherView: View {
    @Binding var searchTerm: String
    @State var weatherData: WeatherData?
    @Binding var currentUnit: Double
    @Binding var currentUnitSymbol: String
    
    var body: some View {
        NavigationStack {
            VStack {
                if let weatherData = weatherData {
                    AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weatherData.weather[0].icon)@4x.png"))
                    Text("\(weatherData.name), \(weatherData.sys.country)")
                        .font(.title)
                    Text("\(Int(round(weatherData.main.temp-currentUnit)))°\(currentUnitSymbol)")
                        .font(.largeTitle)
                    HStack {
                        Text("H: \(Int(round(weatherData.main.temp_max-currentUnit)))°\(currentUnitSymbol)")
                            .font(.subheadline)
                        Text("L: \(Int(round(weatherData.main.temp_min-currentUnit)))°\(currentUnitSymbol)")
                            .font(.subheadline)
                    }
                    Text(weatherData.weather[0].description)
                        .font(.title2)
                    ScrollView (.horizontal){
                        HStack {
                            ExtraDetails(textInfo: "Feels like \(Int(round(weatherData.main.feels_like-currentUnit)))°\(currentUnitSymbol)", imageInfo: "thermometer.low")
                            ExtraDetails(textInfo: "Humidity \(Int(weatherData.main.humidity))%", imageInfo: "humidity")
                            ExtraDetails(textInfo: "Wind Speed: \(Int(round(weatherData.wind.speed)))m/s", imageInfo: "wind")
                            ExtraDetails(textInfo: "Wind Degrees: \(Int(weatherData.wind.deg))", imageInfo: "wind.circle")
                            ExtraDetails(textInfo: "Pressure: \(Int(weatherData.main.pressure))", imageInfo: "rectangle.compress.vertical")
                        }
                        .padding()
                    }
                    .background(Color(red: 0.557, green: 0.557, blue: 0.577, opacity: 0.2))
                    .cornerRadius(15)
                    .padding()
                    Spacer()
                }
                else {
                    Text("No data available")
                }
            }
            .navigationTitle("Search")
            .searchable(text: $searchTerm, prompt: "Search Weather by City")
            .onChange(of: searchTerm) { value in
                if let url = makeWeatherURL(for: value) {
                    fetchWeatherData(from: url)
                }
            }
        }
    }
    
    func makeWeatherURL(for city: String) -> URL? {
        // Create a URLComponents object with the base URL of the API
        var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather")
        
        // Create a URLQueryItem object with the city name
        let cityQuery = URLQueryItem(name: "q", value: city)
        
        // Create another URLQueryItem object with your API key
        let apiKeyQuery = URLQueryItem(name: "appid", value: "2ae6cc613328d5b5cdf16fc6985f3a73")
        
        // Add the query items to the components object
        components?.queryItems = [cityQuery, apiKeyQuery]
        
        // Return the URL object from the components object
        return components?.url
    }

    
    func fetchWeatherData(from url: URL) {
        // Create a URLSession data task with the URL
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Check for errors and status code
            guard let data = data, error == nil, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Error fetching weather data")
                return
            }
            
            // Decode the JSON data into a WeatherData object
            let decoder = JSONDecoder()
            if let weatherData = try? decoder.decode(WeatherData.self, from: data) {
                // Update the state variable on the main thread
                DispatchQueue.main.async {
                    self.weatherData = weatherData
                }
            } else {
                print("Error decoding weather data")
            }
        }.resume()
    }
}
