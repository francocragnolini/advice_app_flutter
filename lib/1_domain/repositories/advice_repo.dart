import 'package:dartz/dartz.dart';

import '../failures/failures.dart';
import 'package:advice_flutter_app/1_domain/entities/advice_entity.dart';

abstract class AdviceRepo {
  Future<Either<Failure, AdviceEntity>> getAdviceFromDataSource();
}
