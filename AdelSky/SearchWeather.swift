import SwiftUI

struct CityView: View {
    @State private var cityName = ""
    @State private var cityWeather: WeatherData?
    @State var isLoading: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack{
                Form{
                    TextField("Enter a city name", text: $cityName)
                    if isLoading {
                        ProgressView()
                    } else {
                        if let cityWeather = cityWeather {
                            HStack{
                                Spacer()
                                Text("\(Int(cityWeather.temperature))°C")
                                    .font(.custom("", size: 70))
                                Spacer()
                            }
                            VStack {
                                Text("\(cityWeather.locationName)")
                                    .font(.title2).bold()
                                Text("\(cityWeather.condition)")
                                    .font(.body).bold()
                                    .foregroundColor(.gray)
                            }
                            Text("Adel Inc.")
                                .bold()
                                .padding()
                                .foregroundColor(.gray)
                        } else {
                            EmptyView()
                        }
                    }
                }
            }
            .navigationTitle("Search")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button("Get Weather") {
                        fetchWeatherData(for: cityName)
                    }
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .offset(x: 0, y: -25)
                }
            }
        }
    }
    private func fetchWeatherData(for cityName: String) {
        let apiKey = "2ae6cc613328d5b5cdf16fc6985f3a73"
        let encodedCityName = cityName.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(encodedCityName ?? "Florida")&appid=\(apiKey)"
        print("API Request URL: \(urlString)")
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                isLoading = true
            }
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
                
                DispatchQueue.main.async {
                    cityWeather = WeatherData(locationName: weatherResponse.name, temperature: weatherResponse.main.temp, condition: weatherResponse.weather.first?.description ?? "")
                    isLoading = false
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
