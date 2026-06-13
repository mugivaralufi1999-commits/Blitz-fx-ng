# Weather Dashboard

A modern, responsive weather dashboard that fetches real-time weather data from the OpenWeatherMap API.

## Features

✨ **Current Weather Display**
- Real-time temperature, humidity, wind speed, and pressure
- Weather condition with animated icons
- "Feels like" temperature
- Visibility and cloudiness percentage

📅 **5-Day Forecast**
- Daily weather predictions
- Temperature trends
- Weather condition icons

📍 **Location Services**
- Search weather by city name
- Geolocation support (use current location)
- Save favorite cities for quick access

💾 **Local Storage**
- Saved cities persist across sessions
- Quick access to favorite locations
- Remove saved cities easily

🎨 **Modern UI**
- Dark theme with glassmorphism design
- Responsive grid layouts
- Smooth animations and transitions
- Mobile-friendly interface

⚡ **Performance**
- Fast API responses
- Optimized rendering
- Minimal bundle size

## Installation

1. Clone the repository or download the files
2. Get a free API key from [OpenWeatherMap](https://openweathermap.org/api)
3. Open `app.js` and replace `YOUR_OPENWEATHERMAP_API_KEY` with your actual API key
4. Open `index.html` in your web browser

## Usage

### Search for Weather
1. Type a city name in the search box
2. Press Enter or click the search button
3. Weather data will display

### Use Geolocation
1. Click the location pin button
2. Allow browser access to your location
3. Weather for your current location will load

### Save Cities
- Cities are automatically saved when you search
- Click on a saved city card to view its weather
- Use the × button to remove a city from favorites

## API Configuration

### Getting Your API Key

1. Visit [OpenWeatherMap](https://openweathermap.org/api)
2. Sign up for a free account
3. Generate an API key from your account settings
4. Copy the key and paste it in `app.js`:

```javascript
const API_KEY = 'YOUR_ACTUAL_API_KEY';
```

## Technical Stack

- **HTML5** - Semantic markup
- **CSS3** - Modern styling with CSS Grid and Flexbox
- **JavaScript (Vanilla)** - No dependencies
- **OpenWeatherMap API** - Weather data source
- **LocalStorage API** - Client-side data persistence
- **Fetch API** - HTTP requests
- **Geolocation API** - Location services

## File Structure

```
weather-dashboard/
├── index.html       # Main HTML structure
├── styles.css       # All styling
├── app.js          # Application logic
└── README.md       # Documentation
```

## Browser Support

- Chrome/Edge (latest)
- Firefox (latest)
- Safari (latest)
- Mobile browsers

## Key Functions

### `fetchWeather(city)`
Fetches weather data for a specified city.

### `fetchWeatherByCoordinates(lat, lon)`
Fetches weather data based on latitude and longitude.

### `fetchForecast(lat, lon)`
Retrieves 5-day forecast data.

### `displayCurrentWeather(data)`
Renders current weather information.

### `displayForecast(forecastData)`
Renders 5-day forecast cards.

### `addToSavedCities(cityName, temp)`
Saves a city to localStorage.

### `removeCity(cityName)`
Removes a city from saved list.

## Customization

### Change Theme Colors
Edit `:root` variables in `styles.css`:

```css
:root {
    --primary-color: #1e88e5;
    --secondary-color: #42a5f5;
    /* ... more colors ... */
}
```

### Add More Weather Details
Modify `displayCurrentWeather()` to include additional OpenWeatherMap data fields.

### Extend Forecast Period
Change the slice value in `displayForecast()`:

```javascript
.slice(0, 7)  // For 7-day forecast instead of 5
```

## Troubleshooting

### "Weather not found"
- Check the city name spelling
- Ensure API key is valid
- Verify internet connection

### Geolocation not working
- Allow location access in browser settings
- Use HTTPS (some browsers require it)
- Check browser geolocation support

### No forecast data
- Verify API key has forecast access
- Check OpenWeatherMap API plan
- Review browser console for errors

## API Rate Limits

Free OpenWeatherMap plan includes:
- 1,000 requests per day
- 60 requests per minute

Consider upgrading for higher limits.

## Future Enhancements

- [ ] Hourly forecast
- [ ] Weather alerts
- [ ] Multiple weather source comparison
- [ ] Weather history/trends
- [ ] Air quality index
- [ ] UV index
- [ ] Wind direction visualization
- [ ] Radar map integration
- [ ] Dark/Light theme toggle
- [ ] Multilingual support

## License

MIT License - Feel free to use and modify

## Author

mugivaralufi1999

## Support

For issues or suggestions, please refer to the OpenWeatherMap documentation:
https://openweathermap.org/api
