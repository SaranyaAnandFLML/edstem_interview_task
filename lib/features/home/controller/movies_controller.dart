import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/movies_model.dart';
import '../repository/movies_repository.dart';


final moviesControllerProvider = StateNotifierProvider<MoviesController, bool>(
      (ref) => MoviesController(
    objectsRepository: ref.watch(moviesRepositoryProvider),
  ),
);

final getMoviesProvider = FutureProvider.family<List<MoviesModel>,String>((ref,search) async {
  final repository = ref.read(moviesRepositoryProvider);
  return repository.getMovies(search);
});

// The controller class that extends StateNotifier<bool>
class MoviesController extends StateNotifier<bool> {
  final MoviesRepository _moviesRepository;
  //Constructor takes the repository and initializes the loading state to false.
  MoviesController({required MoviesRepository objectsRepository})
      : _moviesRepository = objectsRepository,
        super(false); // loading

  //// Method to fetch movies using the repository with the given search query.
  Future<List<MoviesModel>> getMovies(String search) async {
    final events = await _moviesRepository.getMovies(search);
    return events;
  }

}