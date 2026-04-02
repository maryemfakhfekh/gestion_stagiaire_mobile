// lib/features/stagiaire/data/models/stagiaire_model.dart

class StagiaireModel {
  final int id;
  final UtilisateurModel utilisateur;
  final SujetModel sujet;
  final EncadrantModel? encadrant;
  final String dateDebut;
  final String? dateFin;
  final String statusStage;

  StagiaireModel({
    required this.id, required this.utilisateur, required this.sujet,
    this.encadrant, required this.dateDebut, this.dateFin, required this.statusStage,
  });

  factory StagiaireModel.fromJson(Map<String, dynamic> json) => StagiaireModel(
    id:          json['id'],
    utilisateur: UtilisateurModel.fromJson(json['utilisateur']),
    sujet:       SujetModel.fromJson(json['sujet']),
    encadrant:   json['encadrant'] != null ? EncadrantModel.fromJson(json['encadrant']) : null,
    dateDebut:   json['dateDebut'] ?? '',
    dateFin:     json['dateFin'],
    statusStage: json['statusStage'] ?? 'EN_COURS',
  );
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
    required this.id, required this.nomComplet, required this.email,
    this.telephone, this.filiere, this.cycle, this.etablissement,
  });

  factory UtilisateurModel.fromJson(Map<String, dynamic> json) => UtilisateurModel(
    id:            json['id'],
    nomComplet:    json['nomComplet'] ?? '',
    email:         json['email'] ?? '',
    telephone:     json['telephone'],
    filiere:       json['filiere'] != null ? FiliereModel.fromJson(json['filiere']) : null,
    cycle:         json['cycle']   != null ? CycleModel.fromJson(json['cycle'])     : null,
    etablissement: json['etablissement'],
  );
}

class FiliereModel {
  final int id; final String nom;
  FiliereModel({required this.id, required this.nom});
  factory FiliereModel.fromJson(Map<String, dynamic> j) =>
      FiliereModel(id: j['id'], nom: j['nom'] ?? '');
}

class CycleModel {
  final int id; final String nom;
  CycleModel({required this.id, required this.nom});
  factory CycleModel.fromJson(Map<String, dynamic> j) =>
      CycleModel(id: j['id'], nom: j['nom'] ?? '');
}

class EncadrantModel {
  final int id; final String nomComplet; final String email;
  EncadrantModel({required this.id, required this.nomComplet, required this.email});
  factory EncadrantModel.fromJson(Map<String, dynamic> j) =>
      EncadrantModel(id: j['id'], nomComplet: j['nomComplet'] ?? '', email: j['email'] ?? '');
}

class SujetModel {
  final int id; final String titre; final String filiereCible; final String cycleCible;
  SujetModel({required this.id, required this.titre, required this.filiereCible, required this.cycleCible});
  factory SujetModel.fromJson(Map<String, dynamic> j) => SujetModel(
    id: j['id'], titre: j['titre'] ?? '',
    filiereCible: j['filiereCible'] ?? '', cycleCible: j['cycleCible'] ?? '',
  );
}