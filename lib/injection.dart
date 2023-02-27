import 'package:advice_flutter_app/0_data/datasources/advice_remote_datasource.dart';
import 'package:advice_flutter_app/0_data/repositories/advice_repo_impl.dart';
import 'package:advice_flutter_app/1_domain/repositories/advice_repo.dart';
import 'package:advice_flutter_app/1_domain/usecases/advice_usecases.dart';
import 'package:advice_flutter_app/3_application/pages/advice/bloc/advicer_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

// one of the biggest advantages of using a service locator is testing becomes easily.

final sl = GetIt.I; // sl for service locator

// container where will have all the dependecies(bloc, repository, usecases)
// register the classes (layers, state managment)
Future<void> init() async {
  // ! application layer (bloc)
  // factory = every time a new/fresh instance of a class
  sl.registerFactory(() => AdvicerBloc(sl()));

  // ! domain layer
  sl.registerFactory(() => AdviceUsecases(adviceRepo: sl()));

  // ! data layer
  sl.registerFactory<AdviceRepo>(
      () => AdviceRepoImpl(adviceRemoteDatasource: sl()));

  sl.registerFactory<AdviceRemoteDatasource>(
      () => AdviceRemoteDatasourceImpl(client: sl()));

  // ! externs
  // packages like http, dio , etc
  sl.registerFactory(() => http.Client());
}
