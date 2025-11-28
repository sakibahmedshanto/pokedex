import 'package:equatable/equatable.dart';

import '../../../data/models/pokemon_detail_model.dart';

/// States for the Pokemon Detail BLoC.
/// 
/// These states represent the different UI states of the Pokemon Detail screen.
abstract class PokemonDetailState extends Equatable {
  const PokemonDetailState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any detail data is loaded.
class PokemonDetailInitial extends PokemonDetailState {
  const PokemonDetailInitial();
}

/// State when the Pokemon detail is being loaded.
class PokemonDetailLoading extends PokemonDetailState {
  /// The Pokemon name to display while loading
  final String pokemonName;

  const PokemonDetailLoading({required this.pokemonName});

  @override
  List<Object?> get props => [pokemonName];
}

/// State when the Pokemon detail has been successfully loaded.
class PokemonDetailLoaded extends PokemonDetailState {
  /// The complete Pokemon detail information
  final PokemonDetailModel pokemon;

  const PokemonDetailLoaded({required this.pokemon});

  @override
  List<Object?> get props => [pokemon];
}

/// State when an error occurred while loading the Pokemon detail.
class PokemonDetailError extends PokemonDetailState {
  /// The error message to display to the user
  final String message;
  
  /// The Pokemon name (for display purposes)
  final String pokemonName;

  const PokemonDetailError({
    required this.message,
    required this.pokemonName,
  });

  @override
  List<Object?> get props => [message, pokemonName];
}

