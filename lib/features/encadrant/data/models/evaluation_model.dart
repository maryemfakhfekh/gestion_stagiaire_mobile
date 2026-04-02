class EvaluationModel {
	final int id;
	final double note;
	final String commentaire;
	final String dateEvaluation;

	const EvaluationModel({
		required this.id,
		required this.note,
		required this.commentaire,
		required this.dateEvaluation,
	});

	factory EvaluationModel.fromJson(Map<String, dynamic> json) {
		return EvaluationModel(
			id: json['id'] ?? 0,
			note: (json['note'] ?? 0).toDouble(),
			commentaire: json['commentaire'] ?? '',
			dateEvaluation: json['dateEvaluation'] ?? '',
		);
	}
}