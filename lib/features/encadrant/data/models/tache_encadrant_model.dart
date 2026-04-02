enum StatutTacheEncadrant { aFaire, enCours, termine }

extension StatutTacheEncadrantX on StatutTacheEncadrant {
	String get apiValue {
		switch (this) {
			case StatutTacheEncadrant.aFaire: return 'A_FAIRE';
			case StatutTacheEncadrant.enCours: return 'EN_COURS';
			case StatutTacheEncadrant.termine: return 'TERMINEE';
		}
	}

	String get uiLabel {
		switch (this) {
			case StatutTacheEncadrant.aFaire: return 'À faire';
			case StatutTacheEncadrant.enCours: return 'En cours';
			case StatutTacheEncadrant.termine: return 'Terminé';
		}
	}

	static StatutTacheEncadrant fromApi(String? raw) {
		switch ((raw ?? '').toUpperCase()) {
			case 'EN_COURS': return StatutTacheEncadrant.enCours;
			case 'TERMINEE': return StatutTacheEncadrant.termine;
			default: return StatutTacheEncadrant.aFaire;
		}
	}
}

enum PrioriteTacheEncadrant { basse, moyenne, haute, critique }

extension PrioriteTacheEncadrantX on PrioriteTacheEncadrant {
	String get uiLabel {
		switch (this) {
			case PrioriteTacheEncadrant.basse: return 'BASSE';
			case PrioriteTacheEncadrant.moyenne: return 'MOYENNE';
			case PrioriteTacheEncadrant.haute: return 'HAUTE';
			case PrioriteTacheEncadrant.critique: return 'CRITIQUE';
		}
	}

	String get apiValue {
		switch (this) {
			case PrioriteTacheEncadrant.basse: return 'BASSE';
			case PrioriteTacheEncadrant.moyenne: return 'MOYENNE';
			case PrioriteTacheEncadrant.haute: return 'HAUTE';
			case PrioriteTacheEncadrant.critique: return 'CRITIQUE';
		}
	}

	static PrioriteTacheEncadrant fromApi(String? raw) {
		switch ((raw ?? '').toUpperCase()) {
			case 'BASSE': return PrioriteTacheEncadrant.basse;
			case 'HAUTE': return PrioriteTacheEncadrant.haute;
			case 'CRITIQUE': return PrioriteTacheEncadrant.critique;
			default: return PrioriteTacheEncadrant.moyenne;
		}
	}
}

class TacheEncadrantModel {
	final int id;
	final int stagiaireId;
	final String titre;
	final String description;
	final String? dateEcheance;
	final String? dateCreation;
	final StatutTacheEncadrant statut;
	final PrioriteTacheEncadrant priorite;

	const TacheEncadrantModel({
		required this.id,
		required this.stagiaireId,
		required this.titre,
		required this.description,
		this.dateEcheance,
		this.dateCreation,
		required this.statut,
		this.priorite = PrioriteTacheEncadrant.moyenne,
	});

	factory TacheEncadrantModel.fromJson(Map<String, dynamic> json) {
		final stagiaire = json['stagiaire'] as Map<String, dynamic>? ?? {};
		return TacheEncadrantModel(
			id: json['id'] ?? 0,
			stagiaireId: stagiaire['id'] ?? 0,
			titre: json['titre'] ?? '',
			description: json['description'] ?? '',
			dateEcheance: json['dateEcheance']?.toString(),
			dateCreation: json['dateCreation']?.toString(),
			statut: StatutTacheEncadrantX.fromApi(json['statut']?.toString()),
			priorite: PrioriteTacheEncadrantX.fromApi(json['priorite']?.toString()),
		);
	}

	Map<String, dynamic> toJson() => {
		'titre': titre,
		'description': description,
		'dateEcheance': dateEcheance,
		'statut': statut.apiValue,
		'priorite': priorite.apiValue,
	};

	TacheEncadrantModel copyWith({StatutTacheEncadrant? statut}) {
		return TacheEncadrantModel(
			id: id,
			stagiaireId: stagiaireId,
			titre: titre,
			description: description,
			dateEcheance: dateEcheance,
			dateCreation: dateCreation,
			statut: statut ?? this.statut,
			priorite: priorite,
		);
	}
}