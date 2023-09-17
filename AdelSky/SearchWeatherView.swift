import SwiftUI

struct SearchWeatherView: View {
    @Binding var searchTerm: String
    @State private var weatherData: WeatherData?
    @Binding var selected: Int
    @Binding var extraDetailsSelection: Int
    @State var searchHistory: [String] = []

    var body: some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        NavigationStack {
            List {
                if let weatherData = weatherData {
                    HStack {
                        if (extraDetailsSelection == 1) {Spacer()}
                        VStack {
                            ForEach(searchHistory, id: \.self) { item in
                                Text(item)
                            }
                            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weatherData.weather[0].icon)@4x.png"))
                            Text("\(weatherData.name), \(weatherData.sys.country)")
                                .font(.title)
                            Text(convertTemperatureUnit(number: weatherData.main.temp, selected: selected))
                                .font(.largeTitle)
                            HStack {
                                Text("H: \(convertTemperatureUnit(number: weatherData.main.temp_max, selected: selected))")
                                    .font(.subheadline)
                                Text("L: \(convertTemperatureUnit(number: weatherData.main.temp_min, selected: selected))")
                                    .font(.subheadline)
                            }
                            Text(weatherData.weather[0].description)
                                .font(.title2)

                            if (extraDetailsSelection == 2) {
                                LazyVGrid(columns: columns) {
                                    ExtraDetails(textInfo: "Feels like", textInfo2: convertTemperatureUnit(number: weatherData.main.feels_like, selected: selected), imageInfo: "thermometer.low")
                                    ExtraDetails(textInfo: "Humidity", textInfo2: "\(Int(weatherData.main.humidity))%", imageInfo: "humidity")
                                    ExtraDetails(textInfo: "Wind Speed", textInfo2: "\(Int(round(weatherData.wind.speed)))m/s", imageInfo: "wind")
                                    ExtraDetails(textInfo: "Wind Degrees", textInfo2: "\(Int(weatherData.wind.deg))", imageInfo: "wind.circle")
                                    ExtraDetails(textInfo: "Pressure", textInfo2: "\(Int(weatherData.main.pressure))hPa", imageInfo: "rectangle.compress.vertical")
                                    ExtraDetails(textInfo: "Visibility", textInfo2: "\(weatherData.visibility/1000)km", imageInfo: "eye")
                                }
                            }
                        }
                        if (extraDetailsSelection == 1) {Spacer()}
                    }
                    if (extraDetailsSelection == 1){
                        ScrollView (.horizontal){
                            HStack {
                                ExtraDetails(textInfo: "Feels like", textInfo2: convertTemperatureUnit(number: weatherData.main.feels_like, selected: selected), imageInfo: "thermometer.low")
                                ExtraDetails(textInfo: "Humidity", textInfo2: "\(Int(weatherData.main.humidity))%", imageInfo: "humidity")
                                ExtraDetails(textInfo: "Wind Speed", textInfo2: "\(Int(round(weatherData.wind.speed)))m/s", imageInfo: "wind")
                                ExtraDetails(textInfo: "Wind Degrees", textInfo2: "\(Int(weatherData.wind.deg))", imageInfo: "wind.circle")
                                ExtraDetails(textInfo: "Pressure", textInfo2: "\(Int(weatherData.main.pressure))hPa", imageInfo: "rectangle.compress.vertical")
                                ExtraDetails(textInfo: "Visibility", textInfo2: "\(weatherData.visibility/1000)km", imageInfo: "eye")
                            }
                        }
                    }
                }
                else {
                    Text("Search Cities across the Globe")
                }
            }
            .navigationTitle("Search")
            .onChange(of: searchTerm) { value in
                if let url = makeWeatherURL(for: value) {
                    fetchWeatherData(from: url)
                }
            }
        }
        .searchable(text: $searchTerm, prompt: "Search Weather by City")
        .onSubmit (of: .search) {
            if !searchTerm.isEmpty { searchHistory.append(searchTerm) }
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
        print("Fetching weather data from URL: \(url)")
        print(searchHistory)
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Check for errors and status code
            guard let data = data, error == nil, let response = response as? HTTPURLResponse else {
                if let error = error {
                    print("Error: \(error)")
                } else {
                    print("No data received")
                }
                return
            }

            print("Response Status Code: \(response.statusCode)")

            if response.statusCode == 200 {
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
            } else {
                print("Non-200 response: \(response.statusCode)")
            }
        }.resume()
    }

}
