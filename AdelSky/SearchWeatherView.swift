import SwiftUI

struct SearchWeatherView: View {
    @Binding var searchTerm: String
    @State private var weatherData: WeatherData?
    @Binding var selected: Int
    @Binding var extraDetailsSelection: Int
    @Binding var searchHistory: [String]
    
    var body: some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        NavigationStack {
            List {
                if let weatherData = weatherData {
                    if searchTerm.isEmpty {
                        if (!searchHistory.isEmpty) {
                            Section("Search History".localized(), content: {
                                ForEach(searchHistory, id: \.self) { item in
                                    Button(item) {
                                        searchTerm = item
                                        if let url = makeWeatherURL(for: searchTerm) {
                                            fetchWeatherData(from: url)
                                        }
                                    }
                                }
                            })
                        }
                    }
                    else {
                        HStack {
                            if (extraDetailsSelection == 1) {Spacer()}
                            VStack {
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
                                        ExtraDetails(textInfo: "Feels Like".localized(), textInfo2: convertTemperatureUnit(number: weatherData.main.feels_like, selected: selected), imageInfo: "thermometer.low")
                                        ExtraDetails(textInfo: "Humidity".localized(), textInfo2: "\(Int(weatherData.main.humidity))%", imageInfo: "humidity")
                                        ExtraDetails(textInfo: "Wind Speed".localized(), textInfo2: "\(Int(round(weatherData.wind.speed)))m/s", imageInfo: "wind")
                                        ExtraDetails(textInfo: "Wind Degrees".localized(), textInfo2: "\(Int(weatherData.wind.deg))", imageInfo: "wind.circle")
                                        ExtraDetails(textInfo: "Pressure".localized(), textInfo2: "\(Int(weatherData.main.pressure))hPa", imageInfo: "rectangle.compress.vertical")
                                        ExtraDetails(textInfo: "Visibility".localized(), textInfo2: "\(weatherData.visibility/1000)km", imageInfo: "eye")
                                    }
                                }
                            }
                            if (extraDetailsSelection == 1) {Spacer()}
                        }
                        if (extraDetailsSelection == 1){
                            ScrollView (.horizontal){
                                HStack {
                                    ExtraDetails(textInfo: "Feels Like".localized(), textInfo2: convertTemperatureUnit(number: weatherData.main.feels_like, selected: selected), imageInfo: "thermometer.low")
                                    ExtraDetails(textInfo: "Humidity".localized(), textInfo2: "\(Int(weatherData.main.humidity))%", imageInfo: "humidity")
                                    ExtraDetails(textInfo: "Wind Speed".localized(), textInfo2: "\(Int(round(weatherData.wind.speed)))m/s", imageInfo: "wind")
                                    ExtraDetails(textInfo: "Wind Degrees".localized(), textInfo2: "\(Int(weatherData.wind.deg))", imageInfo: "wind.circle")
                                    ExtraDetails(textInfo: "Pressure".localized(), textInfo2: "\(Int(weatherData.main.pressure))hPa", imageInfo: "rectangle.compress.vertical".localized())
                                    ExtraDetails(textInfo: "Visibility".localized(), textInfo2: "\(weatherData.visibility/1000)km", imageInfo: "eye")
                                }
                            }
                        }
                    }
                }
                else {
                    if (!searchHistory.isEmpty) {
                        Section("Search History".localized(), content: {
                            ForEach(searchHistory, id: \.self) { item in
                                Button(item) {
                                    searchTerm = item
                                    if let url = makeWeatherURL(for: searchTerm) {
                                        fetchWeatherData(from: url)
                                    }
                                }
                            }
                        })
                    }
                }
            }
            .navigationTitle("Search".localized())
        }
        .searchable(text: $searchTerm, prompt: "Search Weather by City".localized())
        .onSubmit (of: .search) {
            if let url = makeWeatherURL(for: searchTerm) {
                fetchWeatherData(from: url)
            }
            if !searchTerm.isEmpty && !searchHistory.contains(searchTerm) { searchHistory.append(searchTerm) }
        }
    }

    func makeWeatherURL(for city: String) -> URL? {
        
        var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather")

        
        let cityQuery = URLQueryItem(name: "q", value: city)

        
        let apiKeyQuery = URLQueryItem(name: "appid", value: "2ae6cc613328d5b5cdf16fc6985f3a73")

        
        components?.queryItems = [cityQuery, apiKeyQuery]

        
        return components?.url
    }

    func fetchWeatherData(from url: URL) {
        print("Fetching weather data from URL: \(url)")
        print(searchHistory)
        URLSession.shared.dataTask(with: url) { data, response, error in
            
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
                
                let decoder = JSONDecoder()
                if let weatherData = try? decoder.decode(WeatherData.self, from: data) {
                    
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
