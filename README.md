# PokéDex Flutter Application

<p align="center">
  <img src="https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png" width="150" alt="Pikachu">
</p>

A beautiful and robust Flutter application that displays Pokémon data using the [PokéAPI](https://pokeapi.co/). Built with BLoC pattern for state management, following clean architecture principles.

## Features

- 📱 **Horizontal Scrolling List** - Browse through all Pokémon in an elegant horizontal card view
- 🔍 **Search Functionality** - Search Pokémon by name or ID
- 📊 **Detailed Information** - View comprehensive details including stats, abilities, height, weight, and more
- 🎨 **Type-Based Theming** - Dynamic colors based on Pokémon type
- ⚡ **Smooth Animations** - Hero animations and loading indicators
- 🔄 **Error Handling** - Robust error handling with retry functionality
- 📱 **Responsive Design** - Beautiful UI that adapts to different screen sizes

## Screenshots

| Home Screen | Search | Detail Screen |
|:-----------:|:------:|:-------------:|
| Pokemon list with horizontal scroll | Search functionality | Full pokemon details |

## Technical Stack

| Technology | Purpose |
|-----------|---------|
| **Flutter** | Cross-platform UI framework (latest stable version) |
| **flutter_bloc** | State management using BLoC pattern |
| **equatable** | Value equality for BLoC states and events |
| **http** | HTTP client for API requests |
| **cached_network_image** | Efficient image loading and caching |

## Architecture

This project follows **Clean Architecture** principles with a layered approach:

```
lib/
├── core/                          # Core utilities and shared code
│   ├── constants/
│   │   └── app_constants.dart     # App-wide constants (API URLs, strings)
│   ├── errors/
│   │   └── exceptions.dart        # Custom exception classes
│   └── theme/
│       └── app_theme.dart         # App theming and colors
│
├── data/                          # Data layer
│   ├── datasources/
│   │   └── pokemon_remote_datasource.dart  # API calls
│   ├── models/
│   │   ├── pokemon_model.dart              # Pokemon list model
│   │   └── pokemon_detail_model.dart       # Pokemon detail model
│   └── repositories/
│       └── pokemon_repository.dart         # Repository implementation
│
├── presentation/                  # Presentation layer
│   ├── blocs/
│   │   ├── pokemon_list/
│   │   │   ├── pokemon_list_bloc.dart      # List BLoC logic
│   │   │   ├── pokemon_list_event.dart     # List events
│   │   │   └── pokemon_list_state.dart     # List states
│   │   └── pokemon_detail/
│   │       ├── pokemon_detail_bloc.dart    # Detail BLoC logic
│   │       ├── pokemon_detail_event.dart   # Detail events
│   │       └── pokemon_detail_state.dart   # Detail states
│   ├── screens/
│   │   ├── pokemon_list_screen.dart        # Home screen
│   │   └── pokemon_detail_screen.dart      # Detail screen
│   └── widgets/
│       ├── pokemon_card.dart               # Pokemon card widget
│       ├── loading_widget.dart             # Loading indicator
│       └── error_widget.dart               # Error display
│
└── main.dart                      # App entry point
```

### BLoC Pattern Implementation

#### Pokemon List BLoC
- **Events**: `FetchPokemonList`, `RefreshPokemonList`, `SearchPokemon`, `ClearSearch`
- **States**: `PokemonListInitial`, `PokemonListLoading`, `PokemonListLoaded`, `PokemonListError`

#### Pokemon Detail BLoC
- **Events**: `FetchPokemonDetail`, `ResetPokemonDetail`
- **States**: `PokemonDetailInitial`, `PokemonDetailLoading`, `PokemonDetailLoaded`, `PokemonDetailError`

### Data Flow

```
UI (Screens/Widgets)
        ↓ Events
    BLoC Layer
        ↓ Method calls
   Repository Layer
        ↓ Method calls
   DataSource Layer
        ↓ HTTP requests
     PokéAPI
```

## API Endpoints Used

| Endpoint | Description |
|----------|-------------|
| `GET /pokemon?limit=100000&offset=0` | Fetch all Pokémon names and URLs |
| `GET /pokemon/{id or name}` | Fetch detailed Pokémon information |

## Generative AI Usage

This project was developed with assistance from AI tools. Here's how they were utilized:

### Tools Used
- **Claude AI (Cursor IDE)** - For code generation and architecture guidance

### Key Prompts Used

1. **Initial Architecture Setup**:
   > "Create a Flutter PokéDex application with BLoC state management, clean architecture with separated layers for data, domain, and presentation."

2. **BLoC Implementation**:
   > "Implement BLoC pattern for Pokemon list screen with loading, success, and error states. Include search functionality."

3. **Error Handling**:
   > "Add robust error handling for network failures with custom exceptions and user-friendly error messages."

4. **UI Design**:
   > "Create a beautiful horizontal scrolling list with Pokemon cards, including type-based color theming for the detail screen."

### AI Contribution
- Project structure and architecture design
- BLoC implementation with proper state management
- API integration and error handling
- UI components and theming
- Code documentation and comments

## How to Run

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- An Android/iOS device or emulator

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/pokedex.git
   cd pokedex
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Build Release APK

```bash
flutter build apk --release
```

The APK will be generated at: `build/app/outputs/flutter-apk/app-release.apk`

### Build for iOS

```bash
flutter build ios --release
```

## Project Requirements Met

| Requirement | Status |
|-------------|--------|
| Flutter latest stable version | ✅ |
| BLoC state management | ✅ |
| HTTP package for API calls | ✅ |
| Horizontal scrolling Pokemon list | ✅ |
| Card view for each Pokemon | ✅ |
| Loading, success, and error states | ✅ |
| Navigation to detail screen | ✅ |
| Detail screen with name, height, weight, image | ✅ |
| Clean code with proper naming | ✅ |
| Error handling for network failures | ✅ |
| Loading indicators | ✅ |
| Constants file for configuration | ✅ |

## Best Practices Implemented

- ✅ **Separation of Concerns** - Clean layered architecture
- ✅ **Immutable State** - Using Equatable for state classes
- ✅ **const Constructors** - Used where applicable for performance
- ✅ **final Variables** - Used for non-reassigned variables
- ✅ **Error Handling** - Custom exceptions with user-friendly messages
- ✅ **Code Documentation** - Dartdoc comments throughout
- ✅ **Type Safety** - Proper type annotations
- ✅ **Widget Decomposition** - Small, reusable widgets

## License

This project is created for educational/internship assessment purposes.

## Acknowledgments

- [PokéAPI](https://pokeapi.co/) for the comprehensive Pokémon data
- [Flutter](https://flutter.dev/) team for the amazing framework
- [Bloc Library](https://bloclibrary.dev/) for state management solution
