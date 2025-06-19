# Countries Explorer 🌍

A comprehensive Flutter application that demonstrates **Clean Architecture**, **Dependency Injection**, **BLoC Pattern**, **State Persistence**, and **Smooth Animations** for exploring country information using the REST Countries API. Features include favorites management, theme switching, local caching, search functionality, and delightful user experience with subtle animations and page transitions.

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
- **Country Detail Views** - Tap any country to view comprehensive detailed information
- **Favorites Management** - Add/remove countries to/from favorites with persistence
- **Theme Switching** - Light/Dark/System theme modes with persistence
- **Local Caching** - Offline support with automatic cache management (24-hour validity)
- **Pull to Refresh** - Update countries data with swipe gesture

### User Experience
- **Beautiful UI** - Modern Material Design 3 interface with bottom navigation
- **Country Cards** - Interactive cards with flag images and quick favorite actions
- **Detailed Country Pages** - Full-screen views with statistics, timezones, and flag displays
- **SVG Flag Support** - High-quality scalable flag images with PNG fallbacks
- **Error Handling** - Graceful error states with retry functionality
- **Loading States** - Proper loading indicators throughout the app
- **Responsive Design** - Optimized for different screen sizes
- **Persistent State** - Favorites and theme preferences survive app restarts
- **Smooth Animations** - Delightful page transitions, staggered list animations, and interactive elements
- **Hero Animations** - Seamless shared element transitions between pages
- **Animated Interactions** - Responsive favorite buttons, theme toggles, and navigation elements

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
│   ├── animations/
│   │   ├── animated_widgets.dart              # Custom animated components (staggered lists, cards, buttons)
│   │   └── page_transitions.dart              # Custom page transition animations
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
│           │   ├── countries_page.dart                       # Main page with bottom navigation
│           │   └── country_detail_page.dart                  # Detailed country information page
│           └── widgets/
│               ├── country_card_widget.dart                  # Interactive country cards with navigation
│               ├── countries_list_widget.dart                # Countries list container
│               ├── country_search_widget.dart                # Search functionality widget
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
- **Demographics**: Population count with smart formatting
- **Geography**: Total area with proper units (sq km)
- **Visual Assets**: High-quality SVG and PNG flag images
- **Time Information**: Complete timezone data with visual display

### Caching Strategy:
- **First Load**: Data fetched from API and cached locally
- **Cache Duration**: 24-hour validity period for optimal performance
- **Subsequent Loads**: Served from cache for offline support
- **Manual Refresh**: Pull-to-refresh forces API update
- **Cache Management**: Automatic cleanup of expired cache data
- **Fallback Mechanism**: Cache used when API is unavailable

## 🎬 Animation System

### Custom Animation Components

#### **Page Transitions** (`core/animations/page_transitions.dart`)
- **Slide Transition**: Smooth right-to-left slide with fade effect
- **Fade Scale Transition**: Gentle scale and fade combination  
- **Shared Axis Transition**: Multiple direction options (horizontal, vertical, scaled)

#### **Animated Widgets** (`core/animations/animated_widgets.dart`)
- **SlideInAnimation**: Configurable slide-in animations with delays
- **StaggeredListAnimation**: Sequential animations for list items
- **AnimatedFavoriteButton**: Scale and color transitions for favorite interactions
- **AnimatedCard**: Interactive cards with press animations and elevation changes

### Animation Features
- **Hero Animations**: Seamless transitions for flag images and country names between pages
- **Staggered List Loading**: Countries appear sequentially with smooth slide-in effects
- **Interactive Elements**: Animated favorite buttons, theme toggles, and navigation icons
- **Tab Transitions**: Smooth switching between Home and Favorites with slide animations
- **Loading States**: Animated loading indicators with contextual messages
- **Theme Transitions**: Smooth icon rotation and color transitions when switching themes

## 📱 User Interface

### Navigation Structure:
1. **Bottom Navigation** (with animated tab switching)
   - **Home Tab**: All countries with search functionality and staggered loading animations
   - **Favorites Tab**: Saved favorite countries with smooth transitions

2. **Page Navigation** (with custom transitions)
   - **Countries List → Country Detail**: Animated slide transition with Hero elements
   - **Country Detail**: Full-screen with animated header, flag, and statistics sections
   - **Favorites Integration**: Animated favorite toggles from any page

### Home Tab Features:
- **Animated Search Bar**: Real-time filtering with smooth slide-in animation
- **Interactive Country Cards**: Animated cards with press effects, flag images, and population info
- **Staggered Loading**: Countries appear sequentially with elegant slide-in animations
- **Hero Navigation**: Seamless transitions when tapping country cards for detailed view
- **Animated Favorites**: Heart icons with scale and color transitions for instant toggle
- **Pull to Refresh**: Manual data synchronization with smooth loading animations
- **Animated Theme Toggle**: Icon rotation and smooth transitions when switching themes

### Country Detail Page Features:
- **Hero Flag Animation**: Smooth shared element transition for flag images from list to detail
- **Animated Header**: Slide-in animations for back button, country name, and favorite toggle
- **Sequential Content Loading**: Staggered animations for flag, statistics, and timezone sections
- **High-Quality Flags**: SVG flag images with PNG fallbacks and loading states
- **Animated Statistics**: Key data cards with smooth slide-in effects
- **Timezone Chips**: Visual timezone display with subtle entrance animations
- **Interactive Favorites**: Animated favorite button with scale and color transitions
- **Responsive Layout**: Beautiful card-based statistics with elevation animations

### Favorites Tab Features:
- **Animated Tab Switching**: Smooth slide transitions when switching to favorites
- **Staggered Favorites List**: Sequential slide-in animations for favorite countries
- **Persistent Storage**: Favorites saved using HydratedBloc with smooth state transitions
- **Animated Empty State**: Gentle scale animation for the empty favorites icon
- **Interactive Management**: Animated clear all button and favorite interactions
- **Hero Navigation**: Seamless transitions when tapping favorites to view details

### UI Components:
- **Material Design 3**: Modern, accessible design system with smooth animations
- **Animated Components**: Custom animated cards, buttons, and interactive elements
- **Responsive Layout**: Adapts to different screen sizes with fluid animations
- **Enhanced Loading States**: Animated progress indicators with contextual messages
- **Animated Error Handling**: Error states with scale animations and retry button effects
- **Interactive Navigation**: Bottom navigation with scale animations and smooth tab transitions

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

## 🎨 Animation Implementation

### Custom Page Transitions
```dart
// Slide transition with fade
Navigator.push(
  context,
  PageTransitions.slideTransition(
    CountryDetailPage(country: country),
  ),
);

// Fade scale transition
Navigator.push(
  context,
  PageTransitions.fadeScaleTransition(
    TargetPage(),
  ),
);
```

### Staggered List Animations
```dart
// Sequential slide-in animations for list items
ListView.builder(
  itemBuilder: (context, index) {
    return StaggeredListAnimation(
      index: index,
      child: CountryCardWidget(country: countries[index]),
    );
  },
);
```

### Interactive Animated Elements
```dart
// Animated favorite button with scale and color transitions
AnimatedFavoriteButton(
  isFavorite: isFavorite,
  onTap: () => toggleFavorite(),
);

// Animated card with press effects
AnimatedCard(
  onTap: () => navigateToDetail(),
  child: CardContent(),
);
```

### Hero Animations
```dart
// Shared element transitions between pages
Hero(
  tag: 'flag-${country.name}',
  child: FlagImage(),
);

Hero(
  tag: 'name-${country.name}',
  child: CountryName(),
);
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

- **Lazy Loading**: Dependencies created only when needed via GetIt factory pattern
- **Smart Caching**: 24-hour cache validity reduces unnecessary API calls
- **State Persistence**: Instant app startup with HydratedBloc saved state
- **Efficient Rebuilds**: BLoC pattern minimizes unnecessary UI updates
- **Image Optimization**: SVG flags with PNG fallbacks and loading states
- **Animation Performance**: Hardware-accelerated animations with optimized curves and durations
- **Staggered Loading**: Prevents frame drops by spacing animations over time
- **Navigation Optimization**: Efficient custom page transitions with Hero animations
- **Memory Management**: Proper disposal of animation controllers and listeners
- **Network Optimization**: Dio client with timeouts and retry mechanisms
- **Animation Throttling**: Intelligent delays prevent overwhelming the UI thread

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


## 🙏 Acknowledgments

- [REST Countries API](https://restcountries.com/) for providing comprehensive country data
- Flutter team for the excellent framework and tooling
- BLoC library contributors for robust state management solutions

---

## 📞 Contact

For questions or support, please reach out to the development team.

**Made With Love Happy Coding! 🎉**
