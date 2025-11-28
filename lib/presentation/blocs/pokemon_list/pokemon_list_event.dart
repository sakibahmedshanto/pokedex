import 'package:equatable/equatable.dart';

/// Events for the Pokemon List BLoC.
/// 
/// These events trigger state changes in the Pokemon List BLoC.
abstract class PokemonListEvent extends Equatable {
  const PokemonListEvent();

  @override
  List<Object?> get props => [];
}

/// Event to fetch the list of Pokemon.
class FetchPokemonList extends PokemonListEvent {
  const FetchPokemonList();
}

/// Event to refresh the Pokemon list.
class RefreshPokemonList extends PokemonListEvent {
  const RefreshPokemonList();
}

/// Event to search/filter Pokemon by name.
class SearchPokemon extends PokemonListEvent {
  final String query;

  const SearchPokemon(this.query);

  @override
  List<Object?> get props => [query];
}

/// Event to clear the search filter.
class ClearSearch extends PokemonListEvent {
  const ClearSearch();
}

