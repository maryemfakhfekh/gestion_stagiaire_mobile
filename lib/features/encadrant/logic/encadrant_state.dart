// lib/features/encadrant/logic/encadrant_state.dart

part of 'encadrant_bloc.dart';

class EncadrantState {
	final bool isLoading;
	final String? error;
	final String? successMessage;
	final List<StagiaireEncadrantModel> stagiaires;
	final Map<int, List<TacheEncadrantModel>> tachesByStagiaire;
	final Map<int, EvaluationModel> evaluationsByStagiaire;

	const EncadrantState({
		this.isLoading = false,
		this.error,
		this.successMessage,
		this.stagiaires = const [],
		this.tachesByStagiaire = const {},
		this.evaluationsByStagiaire = const {},
	});

	DashboardEncadrantModel get dashboard {
		final allTaches = tachesByStagiaire.values.expand((v) => v).toList();
		final enAttente = allTaches
				.where((t) => t.statut != StatutTacheEncadrant.termine)
				.length;
		return DashboardEncadrantModel(
			stagiairesCount: stagiaires.length,
			tachesCreees: allTaches.length,
			tachesEnAttente: enAttente,
		);
	}

	EncadrantState copyWith({
		bool? isLoading,
		String? error,
		bool clearError = false,
		String? successMessage,
		bool clearSuccess = false,
		List<StagiaireEncadrantModel>? stagiaires,
		Map<int, List<TacheEncadrantModel>>? tachesByStagiaire,
		Map<int, EvaluationModel>? evaluationsByStagiaire,
	}) {
		return EncadrantState(
			isLoading: isLoading ?? this.isLoading,
			error: clearError ? null : (error ?? this.error),
			successMessage:
			clearSuccess ? null : (successMessage ?? this.successMessage),
			stagiaires: stagiaires ?? this.stagiaires,
			tachesByStagiaire: tachesByStagiaire ?? this.tachesByStagiaire,
			evaluationsByStagiaire:
			evaluationsByStagiaire ?? this.evaluationsByStagiaire,
		);
	}
}