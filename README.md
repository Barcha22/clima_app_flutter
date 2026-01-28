# Clima App - Weather Application

A modern, feature-rich weather application built with Flutter that provides real-time weather information for any location in the world.

## ✨ Features

- **Current Location Weather**: Automatically detects your current location and displays real-time weather data including temperature, weather condition, and condition icon
- **3-Day Forecast**: Get weather forecast for the next 3 days with maximum temperatures and weather conditions
- **City Search with Autocomplete**: Search for weather in any city worldwide with intelligent autocomplete suggestions (filtered from 150+ major cities)
- **Skeleton Loaders**: Smooth loading experience with animated skeleton screens while fetching data
- **Pull-to-Refresh**: Easily refresh weather data by pulling down the screen

## 📸 Screenshots

| Home Page                           | Search Page                          | Results                               |
| ----------------------------------- | ------------------------------------ | ------------------------------------- |
| ![Home](/screenshots/home_page.png) | ![Search](/screenshots/search_1.png) | ![Results](/screenshots/search_2.png) |

### Prerequisites

Before running this application, ensure you have the following installed:

- **Flutter** (Latest stable version)
- **Android Studio** (or VS Code with Dart/Flutter extensions)
- **Android Emulator** or a physical Android device
- **OpenJDK 17+**

### Installation Steps

1. **Clone the Repository**

   ```bash
   git clone <repository-url>
   cd clima_app_flutter
   ```

2. **Get WeatherAPI Key**
   - Navigate to [WeatherAPI](https://www.weatherapi.com/login.aspx)
   - Create an account and log in
   - Copy your API key from the dashboard

3. **Configure Environment Variables**
   - Create a `.env` file in the root directory of the project
   - Add the following line with your API key:
     ```
     MY_API=your_api_key_here
     ```

4. **Install Dependencies**

   ```bash
   flutter pub get
   ```

5. **Run the Application**
   ```bash
   flutter run
   ```

## 📦 Dependencies

The application uses the following key packages:

- **http**: For making HTTP requests to WeatherAPI
- **flutter_dotenv**: For managing environment variables securely
- **shimmer**: For animated skeleton loading screens
- **pull_to_refresh**: For pull-to-refresh functionality
- **geolocator**: For obtaining device location
- **geocoding**: For reverse geocoding coordinates to city names
- **package_info_plus**: For retrieving app information

See `pubspec.yaml` for the complete list of dependencies.

## 🏗️ Project Structure

```
lib/
├── main.dart                 # Application entry point
├── pages/
│   ├── home_page.dart       # Home screen with current weather & forecast
│   ├── search_page.dart     # City search with autocomplete
│   └── main_page.dart       # Navigation between pages
├── services/
│   ├── get_temperature.dart # WeatherAPI integration
│   ├── get_location.dart    # Location services
│   └── get_icons.dart       # Weather icon handling
├── components/
│   ├── card.dart            # Forecast card component
│   └── get_icons.dart       # Icon retrieval component
└── data/
    └── cities.dart          # List of 150+ searchable cities
```

## 🌐 API Integration

This app uses the **WeatherAPI.com** service:

- **Current Weather Endpoint**: `/current.json`
- **Forecast Endpoint**: `/forecast.json`
- Real-time data with high accuracy

## 📝 Notes

- City search is limited to validated cities in the database to prevent invalid API calls
- Autocomplete suggestions are case-insensitive
- Weather data is cached to reduce API calls
- The app requires location permissions to access device location
- Internet connection is required for weather data
