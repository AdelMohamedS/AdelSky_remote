import SwiftUI

struct WeatherData: Codable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

struct Coord: Codable {
    let lon: Double
    let lat: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
}

struct Clouds: Codable {
    let all: Int
}

struct Sys: Codable {
    let type: Int
    let id: Int
    let country: String
    let sunrise: Int
    let sunset: Int
}

struct TestView: View {
    @State private var weatherData: WeatherData?
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                if let weatherData = weatherData {
                    AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(weatherData.weather[0].icon)@4x.png"))
                    Text("City: \(weatherData.name)")
                    Text(weatherData.weather[0].description)
                    Text("\(weatherData.main.temp)°K")
                        .font(.title)
                    Text("\(weatherData.main.temp-273.15)°C")
                        .font(.title)
                    Text("\(weatherData.main.temp-255.372)°F")
                        .font(.title)
                } else {
                    ProgressView()
                }
            }
            .onAppear {
                fetchData()
            }
            .navigationTitle("Temperature")
        }
    }
    
    func fetchData() {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=Cairo&appid=2ae6cc613328d5b5cdf16fc6985f3a73") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                DispatchQueue.main.async {
                    self.weatherData = weatherData
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
