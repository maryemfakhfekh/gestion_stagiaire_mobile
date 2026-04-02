// lib/features/stagiaire/logic/tache_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/tache_repository.dart';
import '../data/models/tache_model.dart';

part 'tache_event.dart';
part 'tache_state.dart';

class TacheBloc extends Bloc<TacheEvent, TacheState> {
  final TacheRepository repository;

  TacheBloc({required this.repository}) : super(TacheInitial()) {
    on<LoadTaches>(_onLoad);
    on<UpdateStatutTache>(_onUpdateStatut);
  }

  Future<void> _onLoad(LoadTaches event, Emitter<TacheState> emit) async {
    emit(TacheLoading());
    try {
      final taches = await repository.getMesTaches();
      emit(TacheLoaded(taches));
    } catch (e) {
      emit(TacheError(e.toString()));
    }
  }

  Future<void> _onUpdateStatut(
      UpdateStatutTache event, Emitter<TacheState> emit) async {
    final current = state;
    if (current is! TacheLoaded) return;
    final updated = current.taches
        .map((t) => t.id == event.id ? t.copyWith(statut: event.statut) : t)
        .toList();
    emit(TacheLoaded(updated));
    try {
      await repository.updateStatut(event.id, _toBackend(event.statut));
    } catch (_) {
      emit(current);
    }
  }

  String _toBackend(TacheStatut s) => switch (s) {
    TacheStatut.enCours  => 'EN_COURS',
    TacheStatut.terminee => 'TERMINEE',
    _                    => 'A_FAIRE',
  };
}