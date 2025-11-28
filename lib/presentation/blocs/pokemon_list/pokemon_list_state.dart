import 'package:equatable/equatable.dart';

import '../../../data/models/pokemon_model.dart';

/// States for the Pokemon List BLoC.
/// 
/// These states represent the different UI states of the Pokemon List screen.
abstract class PokemonListState extends Equatable {
  const PokemonListState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any data is loaded.
class PokemonListInitial extends PokemonListState {
  const PokemonListInitial();
}

/// State when the Pokemon list is being loaded.
class PokemonListLoading extends PokemonListState {
  const PokemonListLoading();
}

/// State when the Pokemon list has been successfully loaded.
class PokemonListLoaded extends PokemonListState {
  /// The complete list of Pokemon from the API
  final List<PokemonModel> allPokemon;
  
  /// The filtered list of Pokemon (based on search query)
  final List<PokemonModel> displayedPokemon;
  
  /// The current search query (empty if no search is active)
  final String searchQuery;

  const PokemonListLoaded({
    required this.allPokemon,
    required this.displayedPokemon,
    this.searchQuery = '',
  });

  /// Creates a copy of this state with optional new values.
  PokemonListLoaded copyWith({
    List<PokemonModel>? allPokemon,
    List<PokemonModel>? displayedPokemon,
    String? searchQuery,
  }) {
    return PokemonListLoaded(
      allPokemon: allPokemon ?? this.allPokemon,
      displayedPokemon: displayedPokemon ?? this.displayedPokemon,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [allPokemon, displayedPokemon, searchQuery];
}

/// State when an error occurred while loading the Pokemon list.
class PokemonListError extends PokemonListState {
  /// The error message to display to the user
  final String message;

  const PokemonListError(this.message);

  @override
  List<Object?> get props => [message];
}

