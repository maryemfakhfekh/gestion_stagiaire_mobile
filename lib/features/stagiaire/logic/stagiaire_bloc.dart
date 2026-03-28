import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/stagiaire_repository.dart';
import '../data/models/stagiaire_model.dart';

// Events
abstract class StagiaireEvent {}
class LoadDossier extends StagiaireEvent {}

// States
abstract class StagiaireState {}
class StagiaireInitial extends StagiaireState {}
class StagiaireLoading extends StagiaireState {}
class StagiaireLoaded extends StagiaireState {
  final StagiaireModel dossier;
  StagiaireLoaded(this.dossier);
}
class StagiaireError extends StagiaireState {
  final String message;
  StagiaireError(this.message);
}

class StagiaireBloc extends Bloc<StagiaireEvent, StagiaireState> {
  final StagiaireRepository repository;

  StagiaireBloc({required this.repository}) : super(StagiaireInitial()) {
    on<LoadDossier>(_onLoadDossier);
  }

  Future<void> _onLoadDossier(
      LoadDossier event,
      Emitter<StagiaireState> emit,
      ) async {
    emit(StagiaireLoading());
    try {
      final dossier = await repository.getMonDossier();
      emit(StagiaireLoaded(dossier));
    } catch (e) {
      emit(StagiaireError(e.toString()));
    }
  }
}