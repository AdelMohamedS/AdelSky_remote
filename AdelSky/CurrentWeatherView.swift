import SwiftUI
import CoreLocation

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

struct CurrentWeatherView: View {
    @State private var weatherData: WeatherData?
    @Binding var currentUnit: Double
    @Binding var currentUnitSymbol: String
    @StateObject private var locationManager = LocationManager()
    
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
                } else {
                    ProgressView()
                }
            }
            .onAppear {
                locationManager.requestLocation()
            }
            .onReceive(locationManager.$location) { location in
                guard let location = location else { return }
                fetchData(for: location)
            }
            .navigationTitle("Weather")
        }
    }
    
    func fetchData(for location: CLLocation) {
        let apiKey = "2ae6cc613328d5b5cdf16fc6985f3a73"
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=\(apiKey)") else { return }
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

struct ExtraDetails: View {
    @State var textInfo: String = ""
    @State var imageInfo: String = ""
    var body: some View {
        VStack {
            Image(systemName: imageInfo)
            Text(textInfo)
        }
        .frame(height: 100)
        .padding(.horizontal)
        .background(.gray)
        .foregroundColor(.white)
        .cornerRadius(15)
    }
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
