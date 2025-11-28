import 'package:equatable/equatable.dart';

/// Events for the Pokemon Detail BLoC.
/// 
/// These events trigger state changes in the Pokemon Detail BLoC.
abstract class PokemonDetailEvent extends Equatable {
  const PokemonDetailEvent();

  @override
  List<Object?> get props => [];
}

/// Event to fetch detailed information for a specific Pokemon.
class FetchPokemonDetail extends PokemonDetailEvent {
  /// The URL to fetch the Pokemon detail from
  final String url;
  
  /// The Pokemon name (for display while loading)
  final String pokemonName;

  const FetchPokemonDetail({
    required this.url,
    required this.pokemonName,
  });

  @override
  List<Object?> get props => [url, pokemonName];
}

/// Event to reset the detail state when leaving the detail screen.
class ResetPokemonDetail extends PokemonDetailEvent {
  const ResetPokemonDetail();
}

