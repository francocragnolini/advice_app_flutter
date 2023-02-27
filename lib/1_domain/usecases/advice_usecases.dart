import 'package:advice_flutter_app/0_data/repositories/advice_repo_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:advice_flutter_app/1_domain/entities/advice_entity.dart';
import 'package:advice_flutter_app/1_domain/failures/failures.dart';

class AdviceUsecases {
  final adviceRepo = AdviceRepoImpl();
  Future<Either<Failure, AdviceEntity>> getAdvice() async {
    return adviceRepo.getAdviceFromDataSource();

    // space for business logic
  }
}


// class AdviceUsecases {
//   Future<Either<Failure, AdviceEntity>> getAdvice() async {
//     // call the repository to get data(failure or data)
//     // proceed with business logic (manipulate data)
//     // for example get an advice
//     await Future.delayed(const Duration(seconds: 3), () {});
//     // call to repo when good => return data not failure
//     // return right(const AdviceEntity(advice: "advice from usecase test", id: 1));
//     // call to repo when bad or logig had error => return failure(left part)
//     return left(ServerFailure());
//   }
// }
