// lib/features/encadrant/logic/encadrant_event.dart

part of 'encadrant_bloc.dart';

abstract class EncadrantEvent {}

class LoadStagiaires extends EncadrantEvent {}

class LoadTaches extends EncadrantEvent {
  final int stagiaireId;
  LoadTaches(this.stagiaireId);
}

// Utilisé dans creer_tache_page.dart
class EncadrantTacheCreated extends EncadrantEvent {
  final int stagiaireId;
  final String titre;
  final String description;
  final DateTime dateEcheance;
  final StatutTacheEncadrant statut;
  EncadrantTacheCreated({
    required this.stagiaireId,
    required this.titre,
    required this.description,
    required this.dateEcheance,
    required this.statut,
  });
}

// Utilisé dans evaluation_page.dart
class EncadrantEvaluationSubmitted extends EncadrantEvent {
  final int stagiaireId;
  final double note;
  final String commentaire;
  EncadrantEvaluationSubmitted({
    required this.stagiaireId,
    required this.note,
    required this.commentaire,
  });
}

class DeleteTache extends EncadrantEvent {
  final int stagiaireId;
  final int tacheId;
  DeleteTache({required this.stagiaireId, required this.tacheId});
}

class LoadEvaluation extends EncadrantEvent {
  final int stagiaireId;
  LoadEvaluation(this.stagiaireId);
}