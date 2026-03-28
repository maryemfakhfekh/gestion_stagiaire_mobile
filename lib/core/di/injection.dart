import 'package:get_it/get_it.dart';
import '../api/dio_client.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/logic/auth_bloc.dart';
import '../../features/internship/data/repositories/internship_repository.dart';
import '../../features/internship/logic/internship_bloc.dart';
import '../../features/stagiaire/data/repositories/stagiaire_repository.dart';
import '../../features/stagiaire/logic/stagiaire_bloc.dart';

final sl = GetIt.instance;

Future<void> initInjection() async {
  sl.registerLazySingleton<DioClient>(() => DioClient());

  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepository(sl<DioClient>()),
  );

  sl.registerLazySingleton<InternshipRepository>(
        () => InternshipRepositoryImpl(sl<DioClient>()),
  );

  sl.registerLazySingleton<StagiaireRepository>(
        () => StagiaireRepository(sl<DioClient>()),
  );

  sl.registerFactory<AuthBloc>(
        () => AuthBloc(authRepository: sl<AuthRepository>()),
  );

  sl.registerFactory<InternshipBloc>(
        () => InternshipBloc(repository: sl<InternshipRepository>()),
  );

  sl.registerFactory<StagiaireBloc>(
        () => StagiaireBloc(repository: sl<StagiaireRepository>()),
  );
}