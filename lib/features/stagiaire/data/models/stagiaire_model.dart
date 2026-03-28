class StagiaireModel {
  final int id;
  final UtilisateurModel utilisateur;
  final CandidatureModel candidature;
  final SujetModel sujet;
  final EncadrantModel? encadrant;
  final String dateDebut;
  final String? dateFin;
  final String statusStage;

  StagiaireModel({
    required this.id,
    required this.utilisateur,
    required this.candidature,
    required this.sujet,
    this.encadrant,
    required this.dateDebut,
    this.dateFin,
    required this.statusStage,
  });

  factory StagiaireModel.fromJson(Map<String, dynamic> json) {
    return StagiaireModel(
      id: json['id'],
      utilisateur: UtilisateurModel.fromJson(json['utilisateur']),
      candidature: CandidatureModel.fromJson(json['candidature']),
      sujet: SujetModel.fromJson(json['sujet']),
      encadrant: json['encadrant'] != null
          ? EncadrantModel.fromJson(json['encadrant'])
          : null,
      dateDebut: json['dateDebut'] ?? '',
      dateFin: json['dateFin'],
      statusStage: json['statusStage'] ?? 'EN_COURS',
    );
  }
}

class UtilisateurModel {
  final int id;
  final String nomComplet;
  final String email;
  final String? telephone;
  final FiliereModel? filiere;
  final CycleModel? cycle;
  final String? etablissement;

  UtilisateurModel({
    required this.id,
    required this.nomComplet,
    required this.email,
    this.telephone,
    this.filiere,
    this.cycle,
    this.etablissement,
  });

  factory UtilisateurModel.fromJson(Map<String, dynamic> json) {
    return UtilisateurModel(
      id: json['id'],
      nomComplet: json['nomComplet'] ?? '',
      email: json['email'] ?? '',
      telephone: json['telephone'],
      filiere: json['filiere'] != null
          ? FiliereModel.fromJson(json['filiere'])
          : null,
      cycle: json['cycle'] != null
          ? CycleModel.fromJson(json['cycle'])
          : null,
      etablissement: json['etablissement'],
    );
  }
}

class FiliereModel {
  final int id;
  final String nom;
  FiliereModel({required this.id, required this.nom});
  factory FiliereModel.fromJson(Map<String, dynamic> json) =>
      FiliereModel(id: json['id'], nom: json['nom'] ?? '');
}

class CycleModel {
  final int id;
  final String nom;
  CycleModel({required this.id, required this.nom});
  factory CycleModel.fromJson(Map<String, dynamic> json) =>
      CycleModel(id: json['id'], nom: json['nom'] ?? '');
}

class EncadrantModel {
  final int id;
  final String nomComplet;
  final String email;
  final String? telephone;

  EncadrantModel({
    required this.id,
    required this.nomComplet,
    required this.email,
    this.telephone,
  });

  factory EncadrantModel.fromJson(Map<String, dynamic> json) {
    return EncadrantModel(
      id: json['id'],
      nomComplet: json['nomComplet'] ?? '',
      email: json['email'] ?? '',
      telephone: json['telephone'],
    );
  }
}

class CandidatureModel {
  final int id;
  final String statut;
  final String dateDepot;
  final SujetModel sujet;

  CandidatureModel({
    required this.id,
    required this.statut,
    required this.dateDepot,
    required this.sujet,
  });

  factory CandidatureModel.fromJson(Map<String, dynamic> json) {
    return CandidatureModel(
      id: json['id'],
      statut: json['statut'] ?? '',
      dateDepot: json['dateDepot'] ?? '',
      sujet: SujetModel.fromJson(json['sujet']),
    );
  }
}

class SujetModel {
  final int id;
  final String titre;
  final String description;
  final String filiereCible;
  final String cycleCible;
  final List<String> competencesCibles;

  SujetModel({
    required this.id,
    required this.titre,
    required this.description,
    required this.filiereCible,
    required this.cycleCible,
    required this.competencesCibles,
  });

  factory SujetModel.fromJson(Map<String, dynamic> json) {
    return SujetModel(
      id: json['id'],
      titre: json['titre'] ?? '',
      description: json['description'] ?? '',
      filiereCible: json['filiereCible'] ?? '',
      cycleCible: json['cycleCible'] ?? '',
      competencesCibles: json['competencesCibles'] != null
          ? List<String>.from(json['competencesCibles'])
          : [],
    );
  }
}