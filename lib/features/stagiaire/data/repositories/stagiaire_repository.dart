import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/api/dio_client.dart';
import '../models/stagiaire_model.dart';

class StagiaireRepository {
  final DioClient _apiClient;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  StagiaireRepository(this._apiClient);

  Future<Map<String, String>> _headers() async {
    final token = await _storage.read(key: 'token') ?? '';
    return {'Authorization': 'Bearer $token'};
  }

  Future<StagiaireModel> getMonDossier() async {
    final headers = await _headers();
    final response = await _apiClient.dio.get(
      '/stagiaires/mon-dossier',
      options: Options(headers: headers),
    );
    return StagiaireModel.fromJson(response.data);
  }

  Future<bool> hasDossier() async {
    final headers = await _headers();
    final response = await _apiClient.dio.get(
      '/stagiaires/has-dossier',
      options: Options(headers: headers),
    );
    return response.data as bool;
  }
}