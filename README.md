<a name="_hlk146055146"></a><a name="ole_link1"></a># CurrentWeatherView Readme

\## Description

The `CurrentWeatherView` SwiftUI view is a part of a weather app that displays the current weather conditions based on the user's location. It provides real-time weather data fetched from the OpenWeatherMap API, including temperature, humidity, wind speed, and more. This view is designed to be flexible and provides extra details in either a horizontal or vertical layout based on user preference.

\## Features

\- Display of current weather data including temperature, location, weather description, and more.

\- Dynamic unit conversion for temperature (Celsius, Fahrenheit, Kelvin) based on user selection.

\- Option to view extra weather details in either a horizontal or vertical layout.

\- Background color and UI customization for extra weather details section.

\## Dependencies

This code relies on the following external libraries and APIs:

\- \*\*SwiftUI\*\*: The primary framework used for creating the user interface.

\- \*\*CoreLocation\*\*: Used to fetch the user's current location.

\- \*\*OpenWeatherMap API\*\*: Used to fetch weather data.

\## Usage

The `CurrentWeatherView` struct can be integrated into your SwiftUI application to display current weather information. To use this view, follow these steps:

1\. Make sure you have imported SwiftUI and CoreLocation in your project.

\```swift

import SwiftUI

import CoreLocation

\```

2\. Create an instance of `LocationManager` to manage location services. This is used to fetch the user's current location.

\```swift

@StateObject private var locationManager = LocationManager()

\```

3\. Initialize your SwiftUI view with `@Binding` properties for `weatherData`, `selected`, and `extraDetailsSelection`. These bindings are used to update the weather data and user preferences within your application.

\```swift

@Binding var weatherData: WeatherData?

@Binding var selected: Int

@Binding var extraDetailsSelection: Int

\```

4\. Customize the appearance and layout of the weather data display, including extra details, according to your application's design.

5\. Implement the `fetchData(for location: CLLocation)` function to fetch weather data based on the user's current location using the OpenWeatherMap API. You'll need an API key to make the API requests.

6\. In the `onAppear` and `onReceive` modifiers, request the user's location and start updating it to trigger the weather data fetch.

7\. Integrate this view into your navigation stack or other navigation components within your SwiftUI application.

\## Customization

\- You can customize the appearance of the weather details and extra details sections by modifying the layout, colors, and fonts in the `CurrentWeatherView` struct.

\- You can also customize the API request URL and response parsing in the `fetchData(for location: CLLocation)` function to suit your application's needs.

\## Credits

This code sample was created by an anonymous developer and is available for educational purposes. If you plan to use it in a production application, please ensure you comply with the terms and conditions of the OpenWeatherMap API and any other relevant legal requirements.

\## License

This code is provided without any explicit license. You are free to use and modify it as needed, but please consider giving credit to the original author and adhere to any licensing requirements of the libraries and APIs used.



\# WeatherData Struct Readme

\## Description

The code defines a set of Swift structs that are used to model weather data received from an external API. These structs are used to decode JSON data into a structured format that can be easily manipulated and displayed in a Swift application. The data represents various weather-related parameters such as temperature, wind speed, humidity, and more.

\## Structs

\### WeatherData

The `WeatherData` struct is the top-level struct representing weather information. It contains the following properties:

\- `coord`: Information about the geographical coordinates of the location.

\- `weather`: An array of `Weather` objects providing details about the weather condition.

\- `base`: A string indicating the data source for weather information.

\- `main`: Information about the main weather parameters like temperature, humidity, and pressure.

\- `visibility`: The visibility in meters.

\- `wind`: Information about wind speed and direction.

\- `clouds`: Information about cloud coverage.

\- `dt`: A timestamp indicating the time of data retrieval.

\- `sys`: Information about the system, including country, sunrise, and sunset times.

\- `timezone`: The timezone offset in seconds.

\- `id`: A unique identifier for the location.

\- `name`: The name of the location.

\- `cod`: A status code indicating the response status.

\### Coord

The `Coord` struct represents the geographical coordinates of the location. It contains the following properties:

\- `lon`: The longitude of the location.

\- `lat`: The latitude of the location.

\### Weather

The `Weather` struct represents information about the weather condition. It contains the following properties:

\- `id`: An identifier for the weather condition.

\- `main`: A short description of the weather condition.

\- `description`: A more detailed description of the weather condition.

\- `icon`: An icon code representing the weather condition.

\### Main

The `Main` struct represents the main weather parameters. It contains the following properties:

\- `temp`: The temperature in Kelvin.

\- `feels\_like`: The "feels like" temperature in Kelvin.

\- `temp\_min`: The minimum temperature in Kelvin.

\- `temp\_max`: The maximum temperature in Kelvin.

\- `pressure`: The atmospheric pressure in hPa (hectopascals).

\- `humidity`: The relative humidity in percentage.

\- `sea\_level`: The atmospheric pressure at sea level (if available).

\- `grnd\_level`: The atmospheric pressure at ground level (if available).

\### Wind

The `Wind` struct represents wind-related information. It contains the following properties:

\- `speed`: The wind speed in meters per second.

\- `deg`: The wind direction in degrees.

\- `gust`: The wind gust speed (if available).

\### Clouds

The `Clouds` struct represents information about cloud coverage. It contains the following property:

\- `all`: The cloudiness in percentage.

\### Sys

The `Sys` struct represents system-related information. It contains the following properties:

\- `type`: The type of system (if available).

\- `id`: An identifier for the system (if available).

\- `country`: The country code of the location.

\- `sunrise`: The time of sunrise as a timestamp.

\- `sunset`: The time of sunset as a timestamp.

\## Usage

These Swift structs can be used in conjunction with the `JSONDecoder` to parse JSON data received from a weather API. You can create instances of these structs to represent weather data in your application and access specific weather parameters as needed.

For example, to access the temperature in Celsius from `Main`:

\```swift

let temperatureInCelsius = (weatherData.main.temp - 273.15)

\```

\## License

This code is provided without any explicit license. You are free to use and modify it as needed for your application. Please ensure compliance with any relevant licensing requirements if you plan to use it in a commercial project or application.



\# SearchWeatherView Readme

\## Description

The `SearchWeatherView` SwiftUI view is a key component of a weather app that allows users to search for weather information by city name. It provides real-time weather data fetched from the OpenWeatherMap API based on the user's search query. This view is designed to be user-friendly, featuring a search bar, search history, and the ability to display weather details with optional extra information.

\## Features

\- Search for weather information by entering a city name in the search bar.

\- Display real-time weather data including temperature, location, weather description, and more.

\- Dynamic unit conversion for temperature (Celsius, Fahrenheit, Kelvin) based on user selection.

\- Option to view extra weather details in either a horizontal or vertical layout.

\- Search history functionality to quickly revisit previous search queries.

\- User-friendly UI with a responsive layout.

\## Dependencies

This code relies on the following external libraries and APIs:

\- \*\*SwiftUI\*\*: The primary framework used for creating the user interface.

\- \*\*OpenWeatherMap API\*\*: Used to fetch weather data based on the user's search query.

\## Usage

The `SearchWeatherView` struct can be integrated into your SwiftUI application to allow users to search for weather information. To use this view, follow these steps:

1\. Make sure you have imported SwiftUI in your project.

\```swift

import SwiftUI

\```

2\. Create an instance of `SearchWeatherView` within your SwiftUI application.

\```swift

@State private var searchTerm: String = ""

@State private var weatherData: WeatherData?

@State private var searchHistory: [String] = []

var body: some View {

`    `SearchWeatherView(searchTerm: $searchTerm, weatherData: $weatherData, selected: $selected, extraDetailsSelection: $extraDetailsSelection, searchHistory: $searchHistory)

}

\```

3\. Customize the appearance and layout of the `SearchWeatherView` to match your application's design.

4\. Implement the `makeWeatherURL(for city: String)` function to construct the API request URL based on the user's search query.

5\. Implement the `fetchWeatherData(from url: URL)` function to fetch weather data from the API using URLSession. You'll need an API key to make the API requests.

6\. Use the `searchHistory` property to maintain a history of previous search queries and update it as needed.

\## Customization

\- You can customize the appearance of the search bar, search history section, and weather details section within the `SearchWeatherView` struct.

\- You can modify the `fetchWeatherData(from url: URL)` function to handle errors, retry logic, or additional data parsing as needed for your application.

\## Credits

This code sample was created by an anonymous developer and is available for educational purposes. If you plan to use it in a production application, please ensure you comply with the terms and conditions of the OpenWeatherMap API and any other relevant legal requirements.

\## License

This code is provided without any explicit license. You are free to use and modify it as needed, but please consider giving credit to the original author and adhere to any licensing requirements of the libraries and APIs used.



\# TabBarView Readme

\## Description

The `TabBarView.swift` file contains the implementation of the main tab bar interface for the "AdelSky" weather application. It allows users to navigate between different views within the app using tabs. The tab bar consists of three main tabs: Current Weather, Search, and Settings. Each tab provides a distinct set of functionalities and views related to weather information and app settings.

\## Features

\- \*\*Current Weather\*\*: Displays the current weather conditions based on the user's location, including temperature, location name, weather description, and additional details.

\- \*\*Search\*\*: Enables users to search for weather information in different cities by entering city names. It includes search history functionality for quick access to previous queries.

\- \*\*Settings\*\*: Allows users to customize app settings, including preferred temperature units, extra weather details layout (horizontal or vertical), and language preferences.

\## Dependencies

This code relies on the following external libraries and APIs:

\- \*\*SwiftUI\*\*: The primary framework used for building the user interface.

\## Usage

To integrate the `TabBarView` into your SwiftUI application, follow these steps:

1\. Import SwiftUI in your project if it's not already imported:

\```swift

import SwiftUI

\```

2\. Create an instance of the `TabBarView` struct and include it in your application's view hierarchy.

\```swift

struct YourAppView: View {

`    `var body: some View {

`        `TabBarView()

`    `}

}

\```

3\. Customize the appearance and behavior of each tab within the `TabBarView` to suit your application's design and functionality.

4\. Configure and use the `@AppStorage` properties to manage app settings and user preferences, such as the selected tab, extra details selection, search history, and language preferences.

5\. Populate the `weatherData` property as needed to provide real-time weather information to the Current Weather view.

\## Customization

\- You can customize the appearance, layout, and behavior of each tab by modifying the corresponding view structs (CurrentWeatherView, SearchWeatherView, SettingsView) and their associated SwiftUI components.

\- Adjust the app settings and user preferences stored in `@AppStorage` properties to align with your application's requirements.

\## Credits

This code was created by Adel The Adroit on 15/09/2023 for the AdelSky weather application. Please credit the author appropriately if you plan to use or modify this code for your own project.

\## License

This code is provided without any explicit license. You are free to use and modify it as needed for your application. Please ensure compliance with any relevant licensing requirements or legal obligations related to third-party libraries or APIs used in your project.



\# StringExtension.swift Readme

\## Description

The `StringExtension.swift` file contains a Swift extension for the `String` type that provides a localization helper function. This extension is a useful utility for localizing strings in your iOS application, making it easier to support multiple languages and provide a localized user experience.

\## Features

\- The `localized()` function is an extension method for `String` that simplifies the localization of strings by using the `NSLocalizedString` function.

\- It retrieves the localized version of the string based on the user's preferred language and the specified localization file (`Localizable.strings`).

\- If a localized version of the string is not found, it falls back to the original string, providing a seamless user experience.

\## Usage

To use the `localized()` function in your Swift code, follow these steps:

1\. Import the `Foundation` framework if it's not already imported:

\```swift

import Foundation

\```

2\. Include the `StringExtension.swift` file in your project.

3\. Use the `localized()` function on any `String` instance that you want to localize:

\```swift

let localizedString = "Hello".localized()

\```

4\. Ensure that you have a `Localizable.strings` file in your project that contains localized versions of the strings used in your application. The `NSLocalizedString` function will look for translations in this file for different languages.

\## Customization

\- You can customize the `tableName` parameter in the `NSLocalizedString` function to specify a different localization file name if you're using a file other than `Localizable.strings`.

\- Customize the `value` parameter to set a default value if the localized string is not found. By default, it uses the original string.

\## Credits

This code was created by Adel The Adroit on 18/09/2023 as part of the AdelSky project. If you find this extension useful, please credit the author accordingly.

\## License

This code is provided without any explicit license. You are free to use and modify it for your application. However, please ensure compliance with any relevant licensing requirements or legal obligations related to localization and internationalization in your project.
