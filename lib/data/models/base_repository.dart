import 'package:dartz/dartz.dart';
import 'package:telling/data/models/failures.dart';
import 'package:telling/data/models/response_base.dart';

typedef ApiCallFunction<T> = Future<ResponseBase<T>> Function();

class BaseRepository<T> {
  Future<Either<Failure, T>> toEither<T>({
    required ApiCallFunction<T> apiCall,
  }) async {
    try {
      ResponseBase<T> response = await apiCall();

      if (response.success) {
        return Right(response.data!);
      } else {
        switch (response.statusCode) {
          case 401:
            return Left(Failure(
              statusCode: response.statusCode,
              message: response.message,
              errors: response.errors,
            ));
          default:
            return Left(Failure(
              statusCode: response.statusCode,
              message: response.message,
              errors: response.errors,
            ));
        }
      }
    } catch (e) {
      print(e);
      return Left(Failure(
        statusCode: 0,
        message: e.toString(),
      ));
    }
  }
}
