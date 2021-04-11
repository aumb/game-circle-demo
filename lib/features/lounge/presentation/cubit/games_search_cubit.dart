import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gamecircle/core/utils/safe_print.dart';
import 'package:gamecircle/features/lounges/domain/entities/game.dart';

part 'games_search_state.dart';

class GamesSearchCubit extends Cubit<GamesSearchState> {
  final List<Game?>? games;

  List<Game?>? _allGames;
  List<Game?>? get allGames => _allGames;

  String query = '';

  GamesSearchCubit({
    required this.games,
  }) : super(GamesSearchInitial()) {
    _allGames = [];
  }

  void search() {
    emit(GamesSearchLoading());

    final _list = games!.where((element) {
      final _originalElement = (element?.name?.contains(query) ?? false) ||
          (element?.nickname?.contains(query) ?? false);
      return _originalElement;
    }).toList();
    _allGames = [];
    _allGames!.addAll(_list);
    safePrint(_allGames!.length.toString());
    if (_allGames!.isEmpty) {
      emit(GamesSearchEmpty());
    } else {
      emit(GamesSearchLoaded());
    }
  }
}
