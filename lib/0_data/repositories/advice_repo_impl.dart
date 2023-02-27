import 'package:advice_flutter_app/0_data/datasources/advice_remote_datasource.dart';
import 'package:advice_flutter_app/0_data/exceptions/exceptions.dart';
import 'package:advice_flutter_app/1_domain/failures/failures.dart';
import 'package:advice_flutter_app/1_domain/entities/advice_entity.dart';
import 'package:advice_flutter_app/1_domain/repositories/advice_repo.dart';
import 'package:dartz/dartz.dart';

class AdviceRepoImpl implements AdviceRepo {
  final AdviceRemoteDatasource adviceRemoteDatasource =
      AdviceRemoteDatasourceImpl();

  @override
  Future<Either<Failure, AdviceEntity>> getAdviceFromDataSource() async {
    try {
      final result = await adviceRemoteDatasource.getRandomAdviceFromApi();
      return right(result);
    } on ServerException catch (_) {
      return left(ServerFailure());
    } catch (e) {
      // handle the exception
      return left(GeneralFailure());
    }
  }
}
