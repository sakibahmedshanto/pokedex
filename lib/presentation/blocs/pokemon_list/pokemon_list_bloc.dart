import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../../data/repositories/pokemon_repository.dart';
import 'pokemon_list_event.dart';
import 'pokemon_list_state.dart';

/// BLoC for managing the Pokemon List screen state.
/// 
/// Handles fetching the Pokemon list from the API, error handling,
/// and search/filter functionality.
class PokemonListBloc extends Bloc<PokemonListEvent, PokemonListState> {
  final PokemonRepository repository;

  PokemonListBloc({required this.repository}) : super(const PokemonListInitial()) {
    on<FetchPokemonList>(_onFetchPokemonList);
    on<RefreshPokemonList>(_onRefreshPokemonList);
    on<SearchPokemon>(_onSearchPokemon);
    on<ClearSearch>(_onClearSearch);
  }

  /// Handles the [FetchPokemonList] event.
  Future<void> _onFetchPokemonList(
    FetchPokemonList event,
    Emitter<PokemonListState> emit,
  ) async {
    emit(const PokemonListLoading());

    try {
      final response = await repository.getPokemonList();
      emit(PokemonListLoaded(
        allPokemon: response.results,
        displayedPokemon: response.results,
      ));
    } on NetworkException catch (e) {
      emit(PokemonListError(e.message));
    } on ServerException catch (e) {
      emit(PokemonListError(e.message));
    } on ParsingException catch (e) {
      emit(PokemonListError(e.message));
    } on NotFoundException catch (e) {
      emit(PokemonListError(e.message));
    } catch (e) {
      emit(const PokemonListError(AppConstants.genericErrorMessage));
    }
  }

  /// Handles the [RefreshPokemonList] event.
  Future<void> _onRefreshPokemonList(
    RefreshPokemonList event,
    Emitter<PokemonListState> emit,
  ) async {
    // Don't show loading state if we already have data
    final currentState = state;
    
    try {
      final response = await repository.getPokemonList();
      
      // Preserve search query if one was active
      if (currentState is PokemonListLoaded && currentState.searchQuery.isNotEmpty) {
        final filteredList = response.results.where((pokemon) {
          return pokemon.name.toLowerCase().contains(
                currentState.searchQuery.toLowerCase(),
              );
        }).toList();
        
        emit(PokemonListLoaded(
          allPokemon: response.results,
          displayedPokemon: filteredList,
          searchQuery: currentState.searchQuery,
        ));
      } else {
        emit(PokemonListLoaded(
          allPokemon: response.results,
          displayedPokemon: response.results,
        ));
      }
    } on NetworkException catch (e) {
      emit(PokemonListError(e.message));
    } on ServerException catch (e) {
      emit(PokemonListError(e.message));
    } on ParsingException catch (e) {
      emit(PokemonListError(e.message));
    } on NotFoundException catch (e) {
      emit(PokemonListError(e.message));
    } catch (e) {
      emit(const PokemonListError(AppConstants.genericErrorMessage));
    }
  }

  /// Handles the [SearchPokemon] event.
  void _onSearchPokemon(
    SearchPokemon event,
    Emitter<PokemonListState> emit,
  ) {
    final currentState = state;
    
    if (currentState is PokemonListLoaded) {
      if (event.query.isEmpty) {
        emit(currentState.copyWith(
          displayedPokemon: currentState.allPokemon,
          searchQuery: '',
        ));
      } else {
        final filteredList = currentState.allPokemon.where((pokemon) {
          return pokemon.name.toLowerCase().contains(event.query.toLowerCase()) ||
                 pokemon.formattedId.contains(event.query);
        }).toList();
        
        emit(currentState.copyWith(
          displayedPokemon: filteredList,
          searchQuery: event.query,
        ));
      }
    }
  }

  /// Handles the [ClearSearch] event.
  void _onClearSearch(
    ClearSearch event,
    Emitter<PokemonListState> emit,
  ) {
    final currentState = state;
    
    if (currentState is PokemonListLoaded) {
      emit(currentState.copyWith(
        displayedPokemon: currentState.allPokemon,
        searchQuery: '',
      ));
    }
  }
}

