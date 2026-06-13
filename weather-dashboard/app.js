// Weather Dashboard Application

const API_KEY = 'YOUR_OPENWEATHERMAP_API_KEY'; // Replace with your API key
const BASE_URL = 'https://api.openweathermap.org/data/2.5';
const FORECAST_URL = 'https://api.openweathermap.org/data/2.5/forecast';

// DOM Elements
const searchInput = document.getElementById('searchInput');
const searchBtn = document.getElementById('searchBtn');
const geolocationBtn = document.getElementById('geolocationBtn');
const loadingSpinner = document.getElementById('loadingSpinner');
const errorMessage = document.getElementById('errorMessage');
const currentWeatherSection = document.getElementById('currentWeather');
const forecastSection = document.getElementById('forecastSection');
const savedCitiesSection = document.getElementById('savedCitiesSection');
const savedCitiesList = document.getElementById('savedCitiesList');

// State
let currentCity = null;
let savedCities = JSON.parse(localStorage.getItem('savedCities')) || [];

// Event Listeners
searchBtn.addEventListener('click', handleSearch);
searchInput.addEventListener('keypress', (e) => {
    if (e.key === 'Enter') handleSearch();
});
geolocationBtn.addEventListener('click', handleGeolocation);

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    renderSavedCities();
    // Load weather for default city if available
    if (savedCities.length > 0) {
        fetchWeather(savedCities[0].name);
    }
});

/**
 * Handle search functionality
 */
function handleSearch() {
    const query = searchInput.value.trim();
    if (query) {
        fetchWeather(query);
        searchInput.value = '';
    }
}

/**
 * Handle geolocation
 */
function handleGeolocation() {
    if (navigator.geolocation) {
        showLoading();
        navigator.geolocation.getCurrentPosition(
            (position) => {
                const { latitude, longitude } = position.coords;
                fetchWeatherByCoordinates(latitude, longitude);
            },
            (error) => {
                showError('Unable to get your location. Please enable location services.');
            }
        );
    } else {
        showError('Geolocation is not supported by your browser.');
    }
}

/**
 * Fetch weather data by city name
 */
async function fetchWeather(city) {
    try {
        showLoading();
        const response = await fetch(
            `${BASE_URL}/weather?q=${city}&appid=${API_KEY}&units=metric`
        );

        if (!response.ok) {
            throw new Error(`Weather not found for "${city}"`);
        }

        const data = await response.json();
        currentCity = data;
        displayCurrentWeather(data);
        fetchForecast(data.coord.lat, data.coord.lon);
        hideLoading();
    } catch (error) {
        showError(error.message);
    }
}

/**
 * Fetch weather data by coordinates
 */
async function fetchWeatherByCoordinates(lat, lon) {
    try {
        showLoading();
        const response = await fetch(
            `${BASE_URL}/weather?lat=${lat}&lon=${lon}&appid=${API_KEY}&units=metric`
        );

        if (!response.ok) {
            throw new Error('Unable to fetch weather data');
        }

        const data = await response.json();
        currentCity = data;
        displayCurrentWeather(data);
        fetchForecast(lat, lon);
        hideLoading();
    } catch (error) {
        showError(error.message);
    }
}

/**
 * Fetch 5-day forecast
 */
async function fetchForecast(lat, lon) {
    try {
        const response = await fetch(
            `${FORECAST_URL}?lat=${lat}&lon=${lon}&appid=${API_KEY}&units=metric`
        );

        if (!response.ok) {
            throw new Error('Unable to fetch forecast data');
        }

        const data = await response.json();
        displayForecast(data.list);
    } catch (error) {
        console.error('Forecast error:', error);
    }
}

/**
 * Display current weather
 */
function displayCurrentWeather(data) {
    const { main, weather, wind, clouds, sys, coord, name } = data;

    document.getElementById('cityName').textContent = `${name}, ${data.sys.country}`;
    document.getElementById('coordinates').textContent = `Lat: ${coord.lat.toFixed(2)}°, Lon: ${coord.lon.toFixed(2)}°`;
    document.getElementById('temperature').textContent = Math.round(main.temp);
    document.getElementById('description').textContent = weather[0].description;
    document.getElementById('feelsLike').textContent = Math.round(main.feels_like);
    document.getElementById('humidity').textContent = main.humidity;
    document.getElementById('windSpeed').textContent = wind.speed.toFixed(1);
    document.getElementById('pressure').textContent = main.pressure;
    document.getElementById('visibility').textContent = (data.visibility / 1000).toFixed(1);
    document.getElementById('cloudiness').textContent = clouds.all;

    // Weather icon
    const iconUrl = `https://openweathermap.org/img/wn/${weather[0].icon}@4x.png`;
    document.getElementById('weatherIcon').src = iconUrl;

    // Update timestamp
    updateTimestamp();

    // Show current weather section
    currentWeatherSection.style.display = 'block';

    // Add to saved cities if new
    addToSavedCities(name, main.temp);
}

/**
 * Display 5-day forecast
 */
function displayForecast(forecastData) {
    const container = document.getElementById('forecastContainer');
    container.innerHTML = '';

    // Group forecast by day (every 8 entries = 24 hours in 3-hour intervals)
    const dailyForecasts = {};

    forecastData.forEach((item) => {
        const date = new Date(item.dt * 1000).toLocaleDateString();
        if (!dailyForecasts[date]) {
            dailyForecasts[date] = item;
        }
    });

    // Create forecast cards for next 5 days
    Object.values(dailyForecasts).slice(0, 5).forEach((item) => {
        const card = createForecastCard(item);
        container.appendChild(card);
    });

    forecastSection.style.display = 'block';
}

/**
 * Create forecast card element
 */
function createForecastCard(item) {
    const card = document.createElement('div');
    card.className = 'forecast-card';

    const date = new Date(item.dt * 1000);
    const formattedDate = date.toLocaleDateString('en-US', {
        month: 'short',
        day: 'numeric'
    });

    const icon = `https://openweathermap.org/img/wn/${item.weather[0].icon}@2x.png`;
    const temp = Math.round(item.main.temp);
    const condition = item.weather[0].main;

    card.innerHTML = `
        <div class="date">${formattedDate}</div>
        <img src="${icon}" alt="${condition}">
        <div class="temp">${temp}°C</div>
        <div class="condition">${condition}</div>
    `;

    return card;
}

/**
 * Add city to saved cities
 */
function addToSavedCities(cityName, temp) {
    const exists = savedCities.some(city => city.name.toLowerCase() === cityName.toLowerCase());
    if (!exists) {
        savedCities.push({ name: cityName, temp: Math.round(temp) });
        localStorage.setItem('savedCities', JSON.stringify(savedCities));
        renderSavedCities();
    }
}

/**
 * Remove city from saved cities
 */
function removeCity(cityName) {
    savedCities = savedCities.filter(city => city.name.toLowerCase() !== cityName.toLowerCase());
    localStorage.setItem('savedCities', JSON.stringify(savedCities));
    renderSavedCities();
}

/**
 * Render saved cities
 */
function renderSavedCities() {
    savedCitiesList.innerHTML = '';

    if (savedCities.length === 0) {
        savedCitiesList.innerHTML = '<p style="grid-column: 1 / -1; text-align: center; color: var(--text-secondary);">No saved cities. Search for a city to save it.</p>';
        return;
    }

    savedCities.forEach((city) => {
        const card = document.createElement('div');
        card.className = 'saved-city-card';
        card.innerHTML = `
            <button class="remove-btn" onclick="removeCity('${city.name}')">×</button>
            <div class="city-name">${city.name}</div>
            <div class="city-temp">${city.temp}°C</div>
        `;
        card.addEventListener('click', (e) => {
            if (!e.target.classList.contains('remove-btn')) {
                fetchWeather(city.name);
            }
        });
        savedCitiesList.appendChild(card);
    });
}

/**
 * Show loading state
 */
function showLoading() {
    loadingSpinner.style.display = 'flex';
    errorMessage.style.display = 'none';
    currentWeatherSection.style.display = 'none';
    forecastSection.style.display = 'none';
}

/**
 * Hide loading state
 */
function hideLoading() {
    loadingSpinner.style.display = 'none';
}

/**
 * Show error message
 */
function showError(message) {
    errorMessage.textContent = message;
    errorMessage.style.display = 'block';
    loadingSpinner.style.display = 'none';
    currentWeatherSection.style.display = 'none';
    forecastSection.style.display = 'none';
}

/**
 * Update timestamp
 */
function updateTimestamp() {
    const now = new Date();
    const time = now.toLocaleTimeString('en-US', {
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit'
    });
    document.getElementById('lastUpdate').textContent = time;
}