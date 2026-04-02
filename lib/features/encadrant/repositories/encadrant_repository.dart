import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/api/dio_client.dart';
import '../data/models/evaluation_model.dart';
import '../data/models/stagiaire_encadrant_model.dart';
import '../data/models/tache_encadrant_model.dart';

class EncadrantRepository {
	final DioClient _apiClient;
	final FlutterSecureStorage _storage = const FlutterSecureStorage();

	EncadrantRepository(this._apiClient);

	Future<Options> _options() async {
		final token = await _storage.read(key: 'token') ?? '';
		return Options(headers: {'Authorization': 'Bearer $token'});
	}

	Future<List<StagiaireEncadrantModel>> getMesStagiaires() async {
		final response = await _apiClient.dio.get(
			'/stagiaires/mes-stagiaires',
			options: await _options(),
		);
		final list = response.data as List;
		return list
				.map((e) => StagiaireEncadrantModel.fromJson(e))
				.toList();
	}

	Future<List<TacheEncadrantModel>> getTachesByStagiaire(
			int stagiaireId) async {
		final response = await _apiClient.dio.get(
			'/taches/stagiaire/$stagiaireId',
			options: await _options(),
		);
		final list = response.data as List;
		return list
				.map((e) => TacheEncadrantModel.fromJson(e))
				.toList();
	}

	Future<TacheEncadrantModel> createTache({
		required int stagiaireId,
		required String titre,
		required String description,
		required String dateEcheance,
		required PrioriteTacheEncadrant priorite,
	}) async {
		final response = await _apiClient.dio.post(
			'/taches/stagiaire/$stagiaireId',
			data: {
				'titre': titre,
				'description': description,
				'dateEcheance': dateEcheance,
				'priorite': priorite.apiValue,
			},
			options: await _options(),
		);
		return TacheEncadrantModel.fromJson(response.data);
	}

	Future<void> deleteTache(int tacheId) async {
		await _apiClient.dio.delete(
			'/taches/$tacheId',
			options: await _options(),
		);
	}

	Future<EvaluationModel> submitEvaluation({
		required int stagiaireId,
		required double note,
		required String commentaire,
	}) async {
		final response = await _apiClient.dio.post(
			'/evaluations/stagiaire/$stagiaireId',
			data: {'note': note, 'commentaire': commentaire},
			options: await _options(),
		);
		return EvaluationModel.fromJson(response.data);
	}

	Future<EvaluationModel> getEvaluation(int stagiaireId) async {
		final response = await _apiClient.dio.get(
			'/evaluations/stagiaire/$stagiaireId',
			options: await _options(),
		);
		return EvaluationModel.fromJson(response.data);
	}
}