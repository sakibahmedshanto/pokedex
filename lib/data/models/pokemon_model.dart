import 'package:equatable/equatable.dart';

/// Model representing a Pokemon from the list endpoint.
/// 
/// This model contains basic information about a Pokemon
/// as returned by the /pokemon endpoint.
class PokemonModel extends Equatable {
  /// The name of the Pokemon
  final String name;
  
  /// The URL to fetch detailed Pokemon data
  final String url;

  const PokemonModel({
    required this.name,
    required this.url,
  });

  /// Creates a PokemonModel from JSON data.
  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    return PokemonModel(
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }

  /// Converts the model to JSON format.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }

  /// Extracts the Pokemon ID from the URL.
  /// The URL format is: https://pokeapi.co/api/v2/pokemon/{id}/
  int get id {
    final uri = Uri.parse(url);
    final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    return int.tryParse(segments.last) ?? 0;
  }

  /// Gets the formatted Pokemon ID (e.g., #001, #025, #150)
  String get formattedId => '#${id.toString().padLeft(3, '0')}';

  /// Gets the capitalized name of the Pokemon
  String get capitalizedName {
    if (name.isEmpty) return name;
    return name[0].toUpperCase() + name.substring(1);
  }

  /// Gets the official artwork URL for this Pokemon
  String get imageUrl {
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
  }

  @override
  List<Object?> get props => [name, url];
}

/// Response model for the Pokemon list endpoint.
class PokemonListResponse extends Equatable {
  /// Total count of Pokemon available
  final int count;
  
  /// URL for the next page (if available)
  final String? next;
  
  /// URL for the previous page (if available)
  final String? previous;
  
  /// List of Pokemon results
  final List<PokemonModel> results;

  const PokemonListResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  /// Creates a PokemonListResponse from JSON data.
  factory PokemonListResponse.fromJson(Map<String, dynamic> json) {
    return PokemonListResponse(
      count: json['count'] as int,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>)
          .map((item) => PokemonModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [count, next, previous, results];
}

