/// Application-wide constants for the PokéDex app.
/// 
/// This file contains all the constant values used throughout the application
/// including API endpoints, styling constants, and configuration values.
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // ============== API Constants ==============
  
  /// Base URL for the PokéAPI
  static const String baseUrl = 'https://pokeapi.co/api/v2';
  
  /// Endpoint to fetch the list of all Pokémon
  static const String pokemonListEndpoint = '/pokemon?limit=100000&offset=0';
  
  /// Base URL for Pokémon sprite images
  static const String spriteBaseUrl = 
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/';
  
  // ============== UI Constants ==============
  
  /// Default padding value used throughout the app
  static const double defaultPadding = 16.0;
  
  /// Card border radius
  static const double cardBorderRadius = 16.0;
  
  /// Pokemon card width for horizontal list
  static const double pokemonCardWidth = 160.0;
  
  /// Pokemon card height for horizontal list
  static const double pokemonCardHeight = 200.0;
  
  /// Default animation duration in milliseconds
  static const int animationDurationMs = 300;
  
  // ============== App Strings ==============
  
  /// App title
  static const String appTitle = 'PokéDex';
  
  /// Error messages
  static const String networkErrorMessage = 
      'Unable to connect to the server. Please check your internet connection.';
  static const String genericErrorMessage = 
      'Something went wrong. Please try again later.';
  static const String noDataMessage = 'No Pokémon data available.';
  
  /// Loading message
  static const String loadingMessage = 'Loading Pokémon...';
}

