import 'package:dartz/dartz.dart';
import 'package:advice_flutter_app/1_domain/entities/advice_entity.dart';
import 'package:advice_flutter_app/1_domain/failures/failures.dart';

import '../repositories/advice_repo.dart';

class AdviceUsecases {
  final AdviceRepo adviceRepo;
  // repository implementation
  AdviceUsecases({required this.adviceRepo});

  Future<Either<Failure, AdviceEntity>> getAdvice() async {
    return adviceRepo.getAdviceFromDataSource();

    // space for business logic
  }
}
