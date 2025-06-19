# Countries Explorer 🌍

A comprehensive Flutter application that demonstrates **Clean Architecture**, **Dependency Injection**, **BLoC Pattern**, and **State Persistence** for exploring country information using the REST Countries API. Features include favorites management, theme switching, local caching, and search functionality.

## 🏗️ Architecture Overview

This project follows **Clean Architecture** principles with:
- **Dependency Injection** using **GetIt**
- **BLoC Pattern** for state management with **HydratedBloc** for persistence
- **Repository Pattern** with both remote and local data sources
- **Use Cases** for business logic encapsulation
- **Clean separation** of domain, data, and presentation layers
- **Local caching** with SharedPreferences
- **State persistence** for favorites and theme preferences

## 📱 Features

### Core Functionality
- **Browse All Countries** - Load and display all countries with detailed information
- **Real-time Search** - Filter countries by name, region, or subregion
- **Favorites Management** - Add/remove countries to/from favorites with persistence
- **Theme Switching** - Light/Dark/System theme modes with persistence
- **Local Caching** - Offline support with automatic cache management
- **Pull to Refresh** - Update countries data with swipe gesture

### User Experience
- **Beautiful UI** - Modern Material Design 3 interface with bottom navigation
- **Error Handling** - Graceful error states with retry functionality
- **Loading States** - Proper loading indicators throughout the app
- **Country Details** - Comprehensive country information display
- **Responsive Design** - Optimized for different screen sizes
- **Persistent State** - Favorites and theme preferences survive app restarts

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.6.1 or higher)
- Dart SDK
- Internet connection (for initial API calls)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd eskalate_test
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

## 📁 Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   └── api.dart                           # API endpoints and configuration
│   ├── di/
│   │   └── dependency_injection.dart          # Complete DI setup with GetIt
│   ├── favorites/
│   │   └── favorites_cubit.dart               # Favorites management with persistence
│   └── theme/
│       ├── app_theme.dart                     # Material Design 3 theme configuration
│       └── theme_cubit.dart                   # Theme switching with persistence
├── features/
│   └── countries/
│       ├── data/
│       │   ├── datasource/
│       │   │   ├── countries_remote_datasource.dart          # Remote datasource interface
│       │   │   ├── countries_remote_datasource_impl.dart     # Dio-based API implementation
│       │   │   ├── countries_local_datasource.dart           # Local datasource interface
│       │   │   ├── countries_local_datasource_impl.dart      # SharedPreferences implementation
│       │   │   └── countries_datasource_factory.dart         # Datasource factory pattern
│       │   ├── model/
│       │   │   └── countries_model.dart                      # Data model with JSON serialization
│       │   ├── repo/
│       │   │   └── countries_repository_impl.dart            # Repository implementation
│       │   └── example_usage.dart                            # Usage examples and patterns
│       ├── domain/
│       │   ├── entity/
│       │   │   └── countries_entity.dart                     # Domain entity (immutable)
│       │   ├── repository/
│       │   │   └── countries_repository.dart                 # Repository interface
│       │   └── usecase/
│       │       ├── get_all_countries_usecase.dart            # Get all countries with caching
│       │       └── get_country_by_name_usecase.dart          # Search specific country
│       └── presentation/
│           ├── bloc/
│           │   ├── countries_bloc.dart                       # Main BLoC with search logic
│           │   ├── countries_event.dart                      # BLoC events
│           │   └── countries_state.dart                      # BLoC states
│           ├── pages/
│           │   └── countries_page.dart                       # Main page with bottom navigation
│           └── widgets/
│               ├── country_card_widget.dart                  # Individual country display
│               └── favorites_page.dart                       # Favorites tab implementation
└── main.dart                                                # App entry point with HydratedBloc setup
```

## 🔧 Dependencies

```yaml
dependencies:
  flutter: sdk: flutter
  
  # HTTP & Networking
  dio: ^5.8.0+1              # HTTP client for API calls
  
  # State Management
  bloc: ^8.1.4               # Core BLoC library
  flutter_bloc: ^8.1.6       # Flutter BLoC widgets
  hydrated_bloc: ^9.1.5      # State persistence for BLoC
  
  # Dependency Injection
  get_it: ^8.0.2             # Service locator for DI
  
  # Storage & Persistence
  shared_preferences: ^2.3.3  # Local key-value storage
  path_provider: ^2.1.5       # Platform-specific paths
  
  # Utilities
  logger: ^2.5.0             # Comprehensive logging
  equatable: ^2.0.7          # Value equality for entities
  flutter_svg: ^2.0.10+1     # SVG image support

dev_dependencies:
  flutter_test: sdk: flutter
  flutter_lints: ^5.0.0      # Linting rules
```

## 🎯 BLoC Implementation

### Events
- **`GetAllCountriesEvent`** - Load all countries (with caching)
- **`RefreshCountriesEvent`** - Force refresh from API
- **`SearchCountriesEvent`** - Real-time search filtering
- **`GetCountryByNameEvent`** - Search for specific country by exact name
- **`ResetCountriesEvent`** - Reset to initial state

### States
- **`CountriesInitial`** - Initial state before any action
- **`CountriesLoading`** - Loading indicator for async operations
- **`CountriesAllLoaded`** - All countries loaded (or filtered results)
- **`CountriesSingleLoaded`** - Single country found by exact name
- **`CountriesNotFound`** - Search returned no results
- **`CountriesError`** - Error occurred with detailed message

### Usage Example
```dart
// Get BLoC instance from dependency injection
final bloc = getIt<CountriesBloc>();

// Dispatch events
bloc.add(const GetAllCountriesEvent());
bloc.add(const RefreshCountriesEvent());
bloc.add(const SearchCountriesEvent(query: 'Germany'));

// Listen to state changes
BlocBuilder<CountriesBloc, CountriesState>(
  builder: (context, state) {
    if (state is CountriesLoading) {
      return const CircularProgressIndicator();
    } else if (state is CountriesAllLoaded) {
      return CountriesList(countries: state.countries);
    } else if (state is CountriesError) {
      return ErrorWidget(message: state.message);
    }
    return const SizedBox.shrink();
  },
)
```

## 🏭 Dependency Injection

The project uses **GetIt** for comprehensive dependency injection with:

### Registered Dependencies:
- **Core Services**: Dio HTTP client, Logger, SharedPreferences
- **Data Sources**: Remote (API) and Local (Cache) implementations
- **Repositories**: Repository pattern implementations
- **Use Cases**: Business logic encapsulation
- **BLoCs**: State management with factory pattern
- **UI Components**: Theme and Favorites cubits

### DI Configuration
```dart
// Initialize all dependencies
await initializeDependencies();

// Configure Dio with interceptors
final dio = getIt<Dio>();
dio.interceptors.add(LogInterceptor()); // Automatic logging
dio.options.connectTimeout = Duration(seconds: 30);

// Use anywhere in the app
final repository = getIt<CountriesRepository>();
final bloc = getIt<CountriesBloc>();
```

## 🌐 API Integration

The app integrates with the [REST Countries API](https://restcountries.com/v3.1) for:

- **GET /v3.1/all** - Fetch all countries data
- **GET /v3.1/name/{name}** - Search country by exact name

### Data Fields Retrieved:
- **Basic Info**: Country name, region, subregion
- **Demographics**: Population count
- **Geography**: Total area
- **Metadata**: Timezones, flag images

### Caching Strategy:
- **First Load**: Data fetched from API and cached locally
- **Subsequent Loads**: Served from cache for offline support
- **Manual Refresh**: Pull-to-refresh forces API update
- **Cache Expiration**: Configurable cache validity period

## 📱 User Interface

### Navigation Structure:
1. **Bottom Navigation**
   - **Home Tab**: All countries with search functionality
   - **Favorites Tab**: Saved favorite countries

### Home Tab Features:
- **Search Bar**: Real-time filtering by name/region/subregion
- **Countries Grid**: Card-based layout with essential information
- **Pull to Refresh**: Manual data synchronization
- **Theme Toggle**: Switch between light/dark modes

### Favorites Tab Features:
- **Persistent Storage**: Favorites saved using HydratedBloc
- **Quick Access**: Easy management of saved countries
- **Favorite Toggle**: Heart icon for add/remove actions

### UI Components:
- **Material Design 3**: Modern, accessible design system
- **Responsive Layout**: Adapts to different screen sizes
- **Loading States**: Skeleton loaders and progress indicators
- **Error Handling**: User-friendly error messages with retry options

## 🔄 State Persistence

### HydratedBloc Integration:
- **Favorites**: Automatically persisted across app sessions
- **Theme Preferences**: Remembers user's theme choice
- **Automatic Restoration**: State restored on app startup

### Storage Implementation:
```dart
// Theme persistence
class ThemeCubit extends HydratedCubit<ThemeMode> {
  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == json['themeMode'],
    );
  }
}

// Favorites persistence  
class FavoritesCubit extends HydratedCubit<FavoritesState> {
  @override
  FavoritesState? fromJson(Map<String, dynamic> json) {
    return FavoritesState(
      favoriteCountries: json['favoriteCountries'].cast<String>(),
    );
  }
}
```

## 🧪 Testing

### Test Structure:
```bash
# Run unit tests
flutter test

# Run widget tests
flutter test test/widget_test

# Run integration tests
flutter test integration_test
```

### Coverage Areas:
- **Unit Tests**: BLoC logic, use cases, repositories
- **Widget Tests**: UI components and interactions
- **Integration Tests**: End-to-end user flows

## 🚀 Building for Production

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 📊 Performance Optimizations

- **Lazy Loading**: Dependencies created only when needed
- **Local Caching**: Reduced API calls with SharedPreferences
- **State Persistence**: Instant app startup with saved state
- **Efficient Rebuilds**: BLoC pattern minimizes unnecessary UI updates
- **Image Optimization**: SVG support for scalable flag icons

## 🔒 Error Handling

### Comprehensive Error Management:
- **Network Errors**: Graceful handling of connectivity issues
- **API Errors**: Detailed error messages from server responses
- **Cache Errors**: Fallback mechanisms for storage failures
- **Validation Errors**: Input validation with user feedback

### Logging Strategy:
- **Development**: Detailed console logging with colors and emojis
- **Production**: Structured logging for crash analytics
- **Performance**: Request/response logging for API monitoring

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [REST Countries API](https://restcountries.com/) for providing comprehensive country data
- Flutter team for the excellent framework and tooling
- BLoC library contributors for robust state management solutions

---

## 📞 Contact

For questions or support, please reach out to the development team.

**Happy Coding! 🎉**
