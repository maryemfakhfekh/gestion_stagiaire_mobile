class StagiaireEncadrantModel {
  final int id;
  final String nomComplet;
  final String email;
  final String? telephone;
  final String sujetTitre;
  final String sujetDescription;
  final List<String> competences;
  final String filiere;
  final String cycle;
  final String? etablissement;
  final String dateDebut;
  final String? dateFin;
  final String statusStage;

  StagiaireEncadrantModel({
    required this.id,
    required this.nomComplet,
    required this.email,
    this.telephone,
    required this.sujetTitre,
    required this.sujetDescription,
    required this.competences,
    required this.filiere,
    required this.cycle,
    this.etablissement,
    required this.dateDebut,
    this.dateFin,
    required this.statusStage,
  });

  factory StagiaireEncadrantModel.fromJson(Map<String, dynamic> json) {
    final utilisateur = json['utilisateur'] as Map<String, dynamic>? ?? {};
    final sujet = json['sujet'] as Map<String, dynamic>? ?? {};
    final filiere = utilisateur['filiere'] as Map<String, dynamic>?;
    final cycle = utilisateur['cycle'] as Map<String, dynamic>?;
    final competences = sujet['competencesCibles'] as List? ?? [];

    return StagiaireEncadrantModel(
      id: json['id'] ?? 0,
      nomComplet: utilisateur['nomComplet'] ?? '',
      email: utilisateur['email'] ?? '',
      telephone: utilisateur['telephone'],
      sujetTitre: sujet['titre']?.toString().trim() ?? '',
      sujetDescription: sujet['description'] ?? '',
      competences: competences.map((e) => e.toString()).toList(),
      filiere: filiere?['nom'] ?? '',
      cycle: cycle?['nom'] ?? '',
      etablissement: utilisateur['etablissement'],
      dateDebut: json['dateDebut'] ?? '',
      dateFin: json['dateFin'],
      statusStage: json['statusStage'] ?? 'EN_COURS',
    );
  }

  String get initiale =>
      nomComplet.trim().isNotEmpty ? nomComplet.trim()[0].toUpperCase() : '?';

  bool get estEnCours => statusStage == 'EN_COURS';
}