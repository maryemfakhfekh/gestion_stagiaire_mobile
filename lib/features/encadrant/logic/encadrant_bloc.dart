// lib/features/encadrant/logic/encadrant_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/encadrant_repository.dart';
import '../data/models/dashboard_encadrant_model.dart';
import '../data/models/evaluation_model.dart';
import '../data/models/stagiaire_encadrant_model.dart';
import '../data/models/tache_encadrant_model.dart';

part 'encadrant_event.dart';
part 'encadrant_state.dart';

class EncadrantBloc extends Bloc<EncadrantEvent, EncadrantState> {
	final EncadrantRepository repository;

	EncadrantBloc({required this.repository}) : super(const EncadrantState()) {
		on<LoadStagiaires>(_onLoadStagiaires);
		on<LoadTaches>(_onLoadTaches);
		on<EncadrantTacheCreated>(_onCreateTache);
		on<DeleteTache>(_onDeleteTache);
		on<EncadrantEvaluationSubmitted>(_onSubmitEvaluation);
		on<LoadEvaluation>(_onLoadEvaluation);
	}

	Future<void> _onLoadStagiaires(
			LoadStagiaires event, Emitter<EncadrantState> emit) async {
		emit(state.copyWith(isLoading: true, clearError: true));
		try {
			final stagiaires = await repository.getMesStagiaires();
			emit(state.copyWith(isLoading: false, stagiaires: stagiaires));
		} catch (e) {
			emit(state.copyWith(isLoading: false, error: e.toString()));
		}
	}

	Future<void> _onLoadTaches(
			LoadTaches event, Emitter<EncadrantState> emit) async {
		try {
			final taches = await repository.getTachesByStagiaire(event.stagiaireId);
			final updated = Map<int, List<TacheEncadrantModel>>.from(
					state.tachesByStagiaire);
			updated[event.stagiaireId] = taches;
			emit(state.copyWith(tachesByStagiaire: updated));
		} catch (e) {
			emit(state.copyWith(error: e.toString()));
		}
	}

	Future<void> _onCreateTache(
			EncadrantTacheCreated event, Emitter<EncadrantState> emit) async {
		emit(state.copyWith(isLoading: true, clearError: true));
		try {
			final dateStr = event.dateEcheance.toIso8601String().split('T')[0];
			final tache = await repository.createTache(
				stagiaireId: event.stagiaireId,
				titre: event.titre,
				description: event.description,
				dateEcheance: dateStr,
				priorite: PrioriteTacheEncadrant.moyenne,
			);
			final updated = Map<int, List<TacheEncadrantModel>>.from(
					state.tachesByStagiaire);
			final list = List<TacheEncadrantModel>.from(
					updated[event.stagiaireId] ?? []);
			list.insert(0, tache);
			updated[event.stagiaireId] = list;
			emit(state.copyWith(
				isLoading: false,
				tachesByStagiaire: updated,
				successMessage: 'Tâche créée avec succès',
			));
		} catch (e) {
			emit(state.copyWith(isLoading: false, error: e.toString()));
		}
	}

	Future<void> _onDeleteTache(
			DeleteTache event, Emitter<EncadrantState> emit) async {
		try {
			await repository.deleteTache(event.tacheId);
			final updated = Map<int, List<TacheEncadrantModel>>.from(
					state.tachesByStagiaire);
			final list = List<TacheEncadrantModel>.from(
					updated[event.stagiaireId] ?? []);
			list.removeWhere((t) => t.id == event.tacheId);
			updated[event.stagiaireId] = list;
			emit(state.copyWith(tachesByStagiaire: updated));
		} catch (e) {
			emit(state.copyWith(error: e.toString()));
		}
	}

	Future<void> _onSubmitEvaluation(
			EncadrantEvaluationSubmitted event, Emitter<EncadrantState> emit) async {
		emit(state.copyWith(isLoading: true, clearError: true));
		try {
			final eval = await repository.submitEvaluation(
				stagiaireId: event.stagiaireId,
				note: event.note,
				commentaire: event.commentaire,
			);
			final updated = Map<int, EvaluationModel>.from(
					state.evaluationsByStagiaire);
			updated[event.stagiaireId] = eval;
			emit(state.copyWith(
				isLoading: false,
				evaluationsByStagiaire: updated,
				successMessage: 'Évaluation soumise',
			));
		} catch (e) {
			emit(state.copyWith(isLoading: false, error: e.toString()));
		}
	}

	Future<void> _onLoadEvaluation(
			LoadEvaluation event, Emitter<EncadrantState> emit) async {
		try {
			final eval = await repository.getEvaluation(event.stagiaireId);
			final updated = Map<int, EvaluationModel>.from(
					state.evaluationsByStagiaire);
			updated[event.stagiaireId] = eval;
			emit(state.copyWith(evaluationsByStagiaire: updated));
		} catch (_) {}
	}
}