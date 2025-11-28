import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../../data/repositories/pokemon_repository.dart';
import 'pokemon_detail_event.dart';
import 'pokemon_detail_state.dart';

/// BLoC for managing the Pokemon Detail screen state.
/// 
/// Handles fetching detailed Pokemon information from the API
/// and managing the loading/error states.
class PokemonDetailBloc extends Bloc<PokemonDetailEvent, PokemonDetailState> {
  final PokemonRepository repository;

  PokemonDetailBloc({required this.repository})
      : super(const PokemonDetailInitial()) {
    on<FetchPokemonDetail>(_onFetchPokemonDetail);
    on<ResetPokemonDetail>(_onResetPokemonDetail);
  }

  /// Handles the [FetchPokemonDetail] event.
  Future<void> _onFetchPokemonDetail(
    FetchPokemonDetail event,
    Emitter<PokemonDetailState> emit,
  ) async {
    emit(PokemonDetailLoading(pokemonName: event.pokemonName));

    try {
      final pokemonDetail = await repository.getPokemonDetail(event.url);
      emit(PokemonDetailLoaded(pokemon: pokemonDetail));
    } on NetworkException catch (e) {
      emit(PokemonDetailError(
        message: e.message,
        pokemonName: event.pokemonName,
      ));
    } on ServerException catch (e) {
      emit(PokemonDetailError(
        message: e.message,
        pokemonName: event.pokemonName,
      ));
    } on ParsingException catch (e) {
      emit(PokemonDetailError(
        message: e.message,
        pokemonName: event.pokemonName,
      ));
    } on NotFoundException catch (e) {
      emit(PokemonDetailError(
        message: e.message,
        pokemonName: event.pokemonName,
      ));
    } catch (e) {
      emit(PokemonDetailError(
        message: AppConstants.genericErrorMessage,
        pokemonName: event.pokemonName,
      ));
    }
  }

  /// Handles the [ResetPokemonDetail] event.
  void _onResetPokemonDetail(
    ResetPokemonDetail event,
    Emitter<PokemonDetailState> emit,
  ) {
    emit(const PokemonDetailInitial());
  }
}

