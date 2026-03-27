enum TacheStatut { aFaire, enCours, terminee }
enum TachePriorite { basse, moyenne, haute, critique }

class Tache {
  final String id;
  final String issueKey;          // Identifiant de la tâche (ex: GS-1)
  final String titre;
  final String? description;
  final TacheStatut statut;
  final TachePriorite priorite;
  final DateTime dateEcheance;
  final DateTime? dateCreation;
  final String? assigneeId;       // ID de l'assigné
  final String? assigneeName;     // Nom de l'assigné (affiché)
  final int? estimation;          // Heures estimées

  Tache({
    required this.id,
    required this.issueKey,
    required this.titre,
    this.description,
    required this.statut,
    this.priorite = TachePriorite.moyenne,
    required this.dateEcheance,
    this.dateCreation,
    this.assigneeId,
    this.assigneeName,
    this.estimation,
  });

  // Copie avec modification
  Tache copyWith({
    TacheStatut? statut,
    String? titre,
    String? description,
    TachePriorite? priorite,
    DateTime? dateEcheance,
    String? assigneeName,
  }) {
    return Tache(
      id: id,
      issueKey: issueKey,
      titre: titre ?? this.titre,
      description: description ?? this.description,
      statut: statut ?? this.statut,
      priorite: priorite ?? this.priorite,
      dateEcheance: dateEcheance ?? this.dateEcheance,
      dateCreation: dateCreation,
      assigneeId: assigneeId,
      assigneeName: assigneeName ?? this.assigneeName,
      estimation: estimation,
    );
  }
}

// Données fictives pour tester (style Jira)
final List<Tache> fakeTaches = [
  Tache(
    id: '1',
    issueKey: 'GS-1',
    titre: 'Configurer l’environnement',
    description: 'Installer Flutter, Android Studio, etc.',
    statut: TacheStatut.terminee,
    priorite: TachePriorite.haute,
    dateEcheance: DateTime(2025, 3, 15),
    assigneeName: 'Ahmed',
  ),
  Tache(
    id: '2',
    issueKey: 'GS-2',
    titre: 'Créer les entités JPA',
    description: 'Modéliser les entités pour Spring Boot',
    statut: TacheStatut.terminee,
    priorite: TachePriorite.haute,
    dateEcheance: DateTime(2025, 3, 20),
    assigneeName: 'Ahmed',
  ),
  Tache(
    id: '3',
    issueKey: 'GS-3',
    titre: 'Implémenter les APIs REST',
    statut: TacheStatut.terminee,
    priorite: TachePriorite.haute,
    dateEcheance: DateTime(2025, 3, 25),
    assigneeName: 'Ahmed',
  ),
  Tache(
    id: '4',
    issueKey: 'GS-4',
    titre: 'Rédiger le rapport de stage',
    description: 'Document final avec architecture et résultats',
    statut: TacheStatut.aFaire,
    priorite: TachePriorite.moyenne,
    dateEcheance: DateTime(2025, 7, 1),
    assigneeName: 'Ahmed',
  ),
  Tache(
    id: '5',
    issueKey: 'GS-5',
    titre: 'Implémenter les CRUD pour les stagiaires',
    statut: TacheStatut.aFaire,
    priorite: TachePriorite.haute,
    dateEcheance: DateTime(2025, 6, 15),
    assigneeName: 'Ahmed',
  ),
  Tache(
    id: '6',
    issueKey: 'GS-6',
    titre: 'Préparer la soutenance',
    description: 'Slides PowerPoint + démo live',
    statut: TacheStatut.aFaire,
    priorite: TachePriorite.basse,
    dateEcheance: DateTime(2025, 7, 10),
    assigneeName: 'Ahmed',
  ),
  Tache(
    id: '7',
    issueKey: 'GS-7',
    titre: 'Intégration Flutter/DIO',
    statut: TacheStatut.enCours,
    priorite: TachePriorite.moyenne,
    dateEcheance: DateTime(2025, 6, 5),
    assigneeName: 'Ahmed',
  ),
];