# Countries Explorer 🌍

A Flutter application that demonstrates **Clean Architecture**, **Dependency Injection**, and **BLoC Pattern** for exploring country information using the REST Countries API.

## 🏗️ Architecture Overview

This project follows **Clean Architecture** principles with:
- **Dependency Injection** using **GetIt**
- **BLoC Pattern** for state management
- **Repository Pattern** for data abstraction
- **Use Cases** for business logic
- **Clean separation** of domain, data, and presentation layers

## 📱 Features

- **Browse All Countries** - Load and display all countries with detailed information
- **Search by Name** - Find specific countries using exact name search
- **Beautiful UI** - Modern Material Design 3 interface with tabs
- **Error Handling** - Graceful error states with retry functionality
- **Loading States** - Proper loading indicators throughout the app
- **Country Details** - Tap any country to view comprehensive information
- **Responsive Design** - Optimized for different screen sizes

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.6.1 or higher)
- Dart SDK
- Internet connection (for API calls)

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
│   │   └── api.dart                    # API endpoints
│   └── di/
│       └── dependency_injection.dart   # Dependency injection setup
├── features/
│   └── countries/
│       ├── data/
│       │   ├── datasource/
│       │   │   ├── countries_remote_datasource.dart           # Abstract datasource
│       │   │   ├── countries_remote_datasource_impl.dart      # Dio implementation
│       │   │   └── countries_datasource_factory.dart         # Datasource factory
│       │   ├── model/
│       │   │   └── countries_model.dart                      # Data model with JSON serialization
│       │   └── repo/
│       │       ├── countries_repository_impl.dart           # Repository implementation
│       │       └── countries_repository_factory.dart        # Repository factory
│       ├── domain/
│       │   ├── entity/
│       │   │   └── countries_entity.dart                    # Domain entity
│       │   ├── repository/
│       │   │   └── countries_repository.dart                # Repository interface
│       │   └── usecase/
│       │       ├── get_all_countries_usecase.dart           # Get all countries use case
│       │       └── get_country_by_name_usecase.dart         # Search by name use case
│       └── presentation/
│           ├── bloc/
│           │   ├── countries_bloc.dart                      # Main BLoC implementation
│           │   ├── countries_event.dart                     # BLoC events
│           │   └── countries_state.dart                     # BLoC states
│           ├── pages/
│           │   └── countries_page.dart                      # Main page with tabs
│           └── widgets/
│               ├── countries_list_widget.dart               # Countries list display
│               └── country_search_widget.dart               # Search functionality
└── main.dart                                               # App entry point
```

## 🔧 Dependencies

```yaml
dependencies:
  flutter: sdk: flutter
  dio: ^5.8.0+1              # HTTP client for API calls
  logger: ^2.5.0             # Logging functionality
  bloc: ^8.1.4               # BLoC state management
  flutter_bloc: ^8.1.6       # Flutter BLoC widgets
  get_it: ^8.0.2             # Dependency injection
  equatable: ^2.0.7          # Value equality for entities
```

## 🎯 BLoC Implementation

### Events
- **`GetAllCountriesEvent`** - Fetch all countries from API
- **`GetCountryByNameEvent`** - Search for specific country by name
- **`ResetCountriesEvent`** - Reset to initial state

### States
- **`CountriesInitial`** - Initial state
- **`CountriesLoading`** - Loading indicator
- **`CountriesAllLoaded`** - All countries successfully loaded
- **`CountriesSingleLoaded`** - Single country found
- **`CountriesNotFound`** - Search returned no results
- **`CountriesError`** - Error occurred during operation

### Usage Example
```dart
// Get BLoC instance from dependency injection
final bloc = getIt<CountriesBloc>();

// Dispatch events
bloc.add(const GetAllCountriesEvent());
bloc.add(const GetCountryByNameEvent(countryName: 'Germany'));

// Listen to state changes
BlocBuilder<CountriesBloc, CountriesState>(
  builder: (context, state) {
    if (state is CountriesLoading) {
      return const CircularProgressIndicator();
    } else if (state is CountriesAllLoaded) {
      return CountriesListWidget(countries: state.countries);
    } else if (state is CountriesError) {
      return Text('Error: ${state.message}');
    }
    return const SizedBox.shrink();
  },
)
```

## 🏭 Dependency Injection

The project uses **GetIt** for dependency injection with proper registration of:

- **Core Dependencies**: Dio HTTP client, Logger
- **Data Sources**: Remote data source implementations
- **Repositories**: Repository implementations
- **Use Cases**: Business logic use cases
- **BLoCs**: State management components

### DI Setup
```dart
// Initialize all dependencies
await initializeDependencies();

// Use anywhere in the app
final repository = getIt<CountriesRepository>();
final bloc = getIt<CountriesBloc>();
```

## 🌐 API Integration

The app integrates with the [REST Countries API](https://restcountries.com/) for:

- **GET /v3.1/all** - Fetch all countries
- **GET /v3.1/name/{name}** - Search country by name

### Data Fields Retrieved:
- Country name
- Region and subregion
- Population
- Area
- Timezones

## 📱 User Interface

### Main Features:
1. **Tabbed Interface**
   - **All Countries Tab**: Load and browse all countries
   - **Search Tab**: Search for specific countries

2. **Countries List**
   - Beautiful card-based layout
   - Essential information display
   - Tap to view detailed information

3. **Search Functionality**
   - Real-time search with validation
   - Detailed country cards for results
   - Error handling for not found cases

4. **Loading & Error States**
   - Proper loading indicators
   - User-friendly error messages
   - Retry functionality

## 🧪 Testing

The architecture supports easy testing with:

- **Unit Tests**: Test use cases and BLoC logic
- **Widget Tests**: Test UI components
- **Integration Tests**: Test complete user flows
- **Mock Dependencies**: Easy mocking with dependency injection

### Running Tests
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## 🔄 Clean Architecture Benefits

### Domain Layer
- **Pure business logic** independent of frameworks
- **Entities** represent core business objects
- **Use Cases** encapsulate business rules
- **Repository Interfaces** define data contracts

### Data Layer
- **Models** with JSON serialization
- **Data Sources** abstract external dependencies
- **Repository Implementations** handle data operations
- **Network layer** with Dio for HTTP requests

### Presentation Layer
- **BLoC** for state management
- **Widgets** for UI components
- **Pages** for screen layouts
- **Dependency injection** for loose coupling

## 📊 Error Handling

Comprehensive error handling throughout the application:

- **Network Errors**: Dio exception handling
- **API Errors**: HTTP status code handling
- **Data Parsing Errors**: JSON serialization error handling
- **User Input Validation**: Form validation and feedback
- **State Management**: BLoC error states

## 🎨 UI/UX Features

- **Material Design 3** theming
- **Responsive layout** for different screen sizes
- **Loading animations** and progress indicators
- **Smooth navigation** between tabs
- **Interactive elements** with proper feedback
- **Accessibility** support

## 🔧 Configuration

### API Configuration
Update `lib/core/constants/api.dart` to modify API endpoints:

```dart
const String baseUrl = 'https://restcountries.com/v3.1';
```

### Logging Configuration
Customize logging in the dependency injection setup:

```dart
Logger(
  printer: PrettyPrinter(
    methodCount: 2,
    errorMethodCount: 8,
    lineLength: 120,
    colors: true,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.none,
  ),
)
```

## 🚀 Performance Optimizations

- **Lazy loading** of dependencies with GetIt
- **Efficient state management** with BLoC
- **HTTP client optimization** with Dio
- **Memory management** with proper widget disposal
- **Network optimization** with connection timeouts

## 📈 Future Enhancements

- [ ] **Offline Support** with local database
- [ ] **Caching** for improved performance
- [ ] **Pagination** for large datasets
- [ ] **Advanced Search** with filters
- [ ] **Favorites** functionality
- [ ] **Dark Theme** support
- [ ] **Internationalization** (i18n)
- [ ] **Unit Tests** coverage
- [ ] **CI/CD** pipeline

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [REST Countries API](https://restcountries.com/) for providing country data
- [Flutter](https://flutter.dev/) framework
- [BLoC Library](https://bloclibrary.dev/) for state management
- [GetIt](https://pub.dev/packages/get_it) for dependency injection
- [Dio](https://pub.dev/packages/dio) for HTTP client

---

## 📞 Contact

For questions or support, please reach out to the development team.

**Happy Coding! 🎉**
