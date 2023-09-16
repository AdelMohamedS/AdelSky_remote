import SwiftUI
import CoreLocation

struct CurrentWeatherView: View {
    @Binding var weatherData: WeatherData?
    @Binding var selected: Int
    @Binding var extraDetailsSelection: Int
    @StateObject private var locationManager = LocationManager()
    var body: some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        NavigationStack {
            if let weatherData = weatherData {
                ScrollView {
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
                                .padding()
                            }
                            .background(Color(red: 0.557, green: 0.557, blue: 0.577, opacity: 0.2))
                            .cornerRadius(10)
                            .padding()
                        }
                        else if (extraDetailsSelection == 2) {
                            LazyVGrid(columns: columns) {
                                ExtraDetails(textInfo: "Feels like", textInfo2: convertTemperatureUnit(number: weatherData.main.feels_like, selected: selected), imageInfo: "thermometer.low")
                                ExtraDetails(textInfo: "Humidity", textInfo2: "\(Int(weatherData.main.humidity))%", imageInfo: "humidity")
                                ExtraDetails(textInfo: "Wind Speed", textInfo2: "\(Int(round(weatherData.wind.speed)))m/s", imageInfo: "wind")
                                ExtraDetails(textInfo: "Wind Degrees", textInfo2: "\(Int(weatherData.wind.deg))", imageInfo: "wind.circle")
                                ExtraDetails(textInfo: "Pressure", textInfo2: "\(Int(weatherData.main.pressure))hPa", imageInfo: "rectangle.compress.vertical")
                                ExtraDetails(textInfo: "Visibility", textInfo2: "\(weatherData.visibility/1000)km", imageInfo: "eye")
                            }
                            .padding()
                            .background(Color(red: 0.557, green: 0.557, blue: 0.577, opacity: 0.2))
                            .cornerRadius(10)
                            .padding()
                        }
                        Spacer()
                    }
                }
                .navigationTitle("My Location")
            }
            else {
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

func convertTemperatureUnit(number: Double, selected: Int) -> String {
    let celsius = number - 273.15
    let fahrenheit = (number - 273.15)*9/5+32
    let kelvin = number
    
    switch (selected){
    case 1: return "\(Int(round(celsius)))ºC"
    case 2: return "\(Int(round(fahrenheit)))ºF"
    case 3: return "\(Int(round(kelvin)))ºK"
    default: return ""
    }
}

struct ExtraDetails: View {
    @State var textInfo: String = ""
    @State var textInfo2: String = ""
    @State var imageInfo: String = ""
    var body: some View {
        VStack {
            HStack {
                Image(systemName: imageInfo)
                Text(textInfo)
            }
            //                Spacer().frame(height: 10)
            Text(textInfo2)
                .font(.title)
        }
        .frame(width: 125, height: 100)
        .padding(.horizontal)
        .background(.gray)
        .foregroundColor(.white)
        .cornerRadius(10)
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
